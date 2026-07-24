import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { Party } from '../../../core/models';

@Component({
  selector: 'app-party-list',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  template: `
    <div class="page-header">
      <h2>Parties</h2>
      <div class="actions">
        <input type="text" class="search-box" placeholder="Search parties..." [(ngModel)]="searchTerm" (ngModelChange)="filterParties()" />
        <select class="filter-select" [(ngModel)]="selectedType" (ngModelChange)="filterParties()">
          <option value="">All Types</option>
          <option value="Customer">Customer</option>
          <option value="Supplier">Supplier</option>
        </select>
        <button class="btn btn-primary" routerLink="new">+ New Party</button>
      </div>
    </div>

    @if (loading()) {
      <div class="loading">Loading parties...</div>
    } @else if (filteredParties().length === 0) {
      <div class="empty-state">No parties found.</div>
    } @else {
      <table class="data-table">
        <thead>
          <tr>
            <th>Party Code</th>
            <th>Party Name</th>
            <th>Type</th>
            <th>GSTIN</th>
            <th>Phone</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          @for (party of filteredParties(); track party.id) {
            <tr>
              <td>{{ party.code }}</td>
              <td>{{ party.name }}</td>
              <td><span class="badge" [class]="'badge-' + party.partyType.toLowerCase()">{{ party.partyType }}</span></td>
              <td>{{ party.gstin ?? '-' }}</td>
              <td>{{ party.phone ?? party.mobile ?? '-' }}</td>
              <td class="action-cell">
                <button class="btn btn-sm btn-info" [routerLink]="['edit', party.id]">Edit</button>
                <button class="btn btn-sm btn-danger" (click)="deleteParty(party)">Delete</button>
              </td>
            </tr>
          }
        </tbody>
      </table>
    }
  `,
  styles: [`
    .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; flex-wrap: wrap; gap: 8px; }
    .page-header h2 { margin: 0; }
    .actions { display: flex; gap: 8px; align-items: center; }
    .search-box, .filter-select { padding: 6px 12px; border: 1px solid #ccc; border-radius: 4px; }
    .search-box { min-width: 200px; }
    .btn { padding: 6px 14px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }
    .btn-primary { background: #1976d2; color: #fff; }
    .btn-sm { padding: 4px 10px; font-size: 12px; }
    .btn-info { background: #0288d1; color: #fff; }
    .btn-danger { background: #d32f2f; color: #fff; }
    .data-table { width: 100%; border-collapse: collapse; background: #fff; }
    .data-table th, .data-table td { padding: 10px 12px; border: 1px solid #e0e0e0; text-align: left; }
    .data-table th { background: #f5f5f5; font-weight: 600; }
    .data-table tr:hover { background: #f9f9f9; }
    .action-cell { white-space: nowrap; display: flex; gap: 4px; }
    .badge { padding: 3px 8px; border-radius: 10px; font-size: 11px; color: #fff; }
    .badge-customer { background: #1976d2; }
    .badge-supplier { background: #388e3c; }
    .loading, .empty-state { padding: 40px; text-align: center; color: #666; }
  `]
})
export class PartyListComponent implements OnInit {
  private api = inject(ApiService);

  parties = signal<Party[]>([]);
  filteredParties = signal<Party[]>([]);
  loading = signal(true);
  searchTerm = '';
  selectedType = '';

  ngOnInit(): void {
    this.loadParties();
  }

  loadParties(): void {
    this.loading.set(true);
    this.api.getAllParties().subscribe({
      next: (data) => {
        this.parties.set(data);
        this.filterParties();
        this.loading.set(false);
      },
      error: () => this.loading.set(false)
    });
  }

  filterParties(): void {
    let result = this.parties();
    if (this.searchTerm) {
      const term = this.searchTerm.toLowerCase();
      result = result.filter(p =>
        p.code.toLowerCase().includes(term) ||
        p.name.toLowerCase().includes(term) ||
        (p.gstin ?? '').toLowerCase().includes(term)
      );
    }
    if (this.selectedType) {
      result = result.filter(p => p.partyType === this.selectedType);
    }
    this.filteredParties.set(result);
  }

  deleteParty(party: Party): void {
    if (confirm(`Delete party "${party.name}"?`)) {
      this.api.deleteParty(party.id).subscribe(() => this.loadParties());
    }
  }
}
