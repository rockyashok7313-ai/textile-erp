import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { ApiService } from '../../core/services/api.service';
import { StockSummary } from '../../core/models';

@Component({
  selector: 'app-stock-list',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  template: `
    <div class="page-header">
      <h2>Stock Summary</h2>
      <div class="actions">
        <input type="text" class="search-box" placeholder="Search items..." [(ngModel)]="searchTerm" (ngModelChange)="filterStock()" />
        <label class="toggle-label">
          <input type="checkbox" [(ngModel)]="showLowStockOnly" (ngModelChange)="filterStock()" />
          Low Stock Only
        </label>
      </div>
    </div>

    @if (loading()) {
      <div class="loading">Loading stock...</div>
    } @else if (filteredStock().length === 0) {
      <div class="empty-state">No stock records found.</div>
    } @else {
      <table class="data-table">
        <thead>
          <tr>
            <th>Item Name</th>
            <th>Godown</th>
            <th>Opening Qty</th>
            <th>Received Qty</th>
            <th>Issued Qty</th>
            <th>Closing Qty</th>
            <th>Closing Value</th>
            <th>Closing Rate</th>
            <th>Last Updated</th>
          </tr>
        </thead>
        <tbody>
          @for (s of filteredStock(); track s.id) {
            <tr [class.low-stock-row]="isLowStock(s)">
              <td>{{ s.item?.name ?? ('Item #' + s.itemId) }}</td>
              <td>{{ s.godown?.name ?? '-' }}</td>
              <td>{{ s.openingQuantity ?? 0 }}</td>
              <td>{{ s.receivedQuantity ?? 0 }}</td>
              <td>{{ s.issuedQuantity ?? 0 }}</td>
              <td [class.stock-warning]="isLowStock(s)">{{ s.closingQuantity ?? 0 }}</td>
              <td>{{ s.closingValue | number:'1.2-2' }}</td>
              <td>{{ s.closingRate | number:'1.2-2' }}</td>
              <td>{{ s.updatedAt | date:'dd/MM/yyyy HH:mm' }}</td>
            </tr>
          }
        </tbody>
        <tfoot>
          <tr class="totals-row">
            <td colspan="2"><strong>Totals</strong></td>
            <td><strong>{{ totalOpening() | number:'1.2-2' }}</strong></td>
            <td><strong>{{ totalReceived() | number:'1.2-2' }}</strong></td>
            <td><strong>{{ totalIssued() | number:'1.2-2' }}</strong></td>
            <td><strong>{{ totalClosing() | number:'1.2-2' }}</strong></td>
            <td><strong>{{ totalValue() | number:'1.2-2' }}</strong></td>
            <td></td>
            <td></td>
          </tr>
        </tfoot>
      </table>
    }
  `,
  styles: [`
    .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; flex-wrap: wrap; gap: 8px; }
    .page-header h2 { margin: 0; }
    .actions { display: flex; gap: 12px; align-items: center; }
    .search-box { padding: 6px 12px; border: 1px solid #ccc; border-radius: 4px; min-width: 220px; }
    .toggle-label { display: flex; align-items: center; gap: 6px; font-size: 14px; cursor: pointer; }
    .data-table { width: 100%; border-collapse: collapse; background: #fff; }
    .data-table th, .data-table td { padding: 10px 12px; border: 1px solid #e0e0e0; text-align: left; }
    .data-table th { background: #f5f5f5; font-weight: 600; }
    .data-table tr:hover { background: #f9f9f9; }
    .low-stock-row { background: #fff3e0 !important; }
    .stock-warning { color: #d32f2f; font-weight: 600; }
    .totals-row { background: #f5f5f5; }
    .totals-row td { border-top: 2px solid #ccc; }
    .loading, .empty-state { padding: 40px; text-align: center; color: #666; }
  `]
})
export class StockListComponent implements OnInit {
  private api = inject(ApiService);

  stock = signal<StockSummary[]>([]);
  filteredStock = signal<StockSummary[]>([]);
  loading = signal(true);
  searchTerm = '';
  showLowStockOnly = false;

  ngOnInit(): void {
    this.loadStock();
  }

  loadStock(): void {
    this.loading.set(true);
    this.api.getAllStock().subscribe({
      next: (data) => {
        this.stock.set(data);
        this.filterStock();
        this.loading.set(false);
      },
      error: () => this.loading.set(false)
    });
  }

  filterStock(): void {
    let result = this.stock();
    if (this.searchTerm) {
      const term = this.searchTerm.toLowerCase();
      result = result.filter(s =>
        (s.item?.name ?? '').toLowerCase().includes(term) ||
        (s.item?.code ?? '').toLowerCase().includes(term) ||
        (s.godown?.name ?? '').toLowerCase().includes(term)
      );
    }
    if (this.showLowStockOnly) {
      result = result.filter(s => this.isLowStock(s));
    }
    this.filteredStock.set(result);
  }

  isLowStock(s: StockSummary): boolean {
    return (s.closingQuantity ?? 0) <= 0;
  }

  totalOpening(): number {
    return this.filteredStock().reduce((sum, s) => sum + (s.openingQuantity ?? 0), 0);
  }

  totalReceived(): number {
    return this.filteredStock().reduce((sum, s) => sum + (s.receivedQuantity ?? 0), 0);
  }

  totalIssued(): number {
    return this.filteredStock().reduce((sum, s) => sum + (s.issuedQuantity ?? 0), 0);
  }

  totalClosing(): number {
    return this.filteredStock().reduce((sum, s) => sum + (s.closingQuantity ?? 0), 0);
  }

  totalValue(): number {
    return this.filteredStock().reduce((sum, s) => sum + (s.closingValue ?? 0), 0);
  }
}
