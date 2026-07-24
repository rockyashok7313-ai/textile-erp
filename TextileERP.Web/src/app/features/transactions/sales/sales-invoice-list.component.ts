import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { SalesInvoice } from '../../../core/models';

@Component({
  selector: 'app-sales-invoice-list',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  template: `
    <div class="page-header">
      <h2>Sales Invoices</h2>
      <div class="actions">
        <input type="text" class="search-box" placeholder="Search invoices..." [(ngModel)]="searchTerm" (ngModelChange)="filterInvoices()" />
        <select class="filter-select" [(ngModel)]="selectedStatus" (ngModelChange)="filterInvoices()">
          <option value="">All Status</option>
          <option value="Draft">Draft</option>
          <option value="Posted">Posted</option>
          <option value="Cancelled">Cancelled</option>
        </select>
        <button class="btn btn-primary" routerLink="new">+ New Invoice</button>
      </div>
    </div>

    @if (loading()) {
      <div class="loading">Loading invoices...</div>
    } @else if (filteredInvoices().length === 0) {
      <div class="empty-state">No invoices found.</div>
    } @else {
      <table class="data-table">
        <thead>
          <tr>
            <th>Invoice #</th>
            <th>Date</th>
            <th>Customer</th>
            <th>Total Amount</th>
            <th>Net Amount</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          @for (inv of filteredInvoices(); track inv.id) {
            <tr>
              <td>{{ inv.invoiceNumber }}</td>
              <td>{{ inv.invoiceDate | date:'dd/MM/yyyy' }}</td>
              <td>{{ inv.customer?.name ?? '-' }}</td>
              <td>{{ inv.totalGrossAmount | number:'1.2-2' }}</td>
              <td>{{ inv.grandTotal | number:'1.2-2' }}</td>
              <td>
                <span class="status-badge" [class]="'status-' + inv.status.toLowerCase()">{{ inv.status }}</span>
              </td>
              <td class="action-cell">
                <button class="btn btn-sm btn-info" [routerLink]="['edit', inv.id]">View</button>
                @if (inv.status === 'Draft') {
                  <button class="btn btn-sm btn-success" (click)="postInvoice(inv)">Post</button>
                  <button class="btn btn-sm btn-danger" (click)="deleteInvoice(inv)">Delete</button>
                }
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
    .btn-success { background: #388e3c; color: #fff; }
    .btn-sm { padding: 4px 10px; font-size: 12px; }
    .btn-info { background: #0288d1; color: #fff; }
    .btn-danger { background: #d32f2f; color: #fff; }
    .data-table { width: 100%; border-collapse: collapse; background: #fff; }
    .data-table th, .data-table td { padding: 10px 12px; border: 1px solid #e0e0e0; text-align: left; }
    .data-table th { background: #f5f5f5; font-weight: 600; }
    .data-table tr:hover { background: #f9f9f9; }
    .action-cell { white-space: nowrap; display: flex; gap: 4px; }
    .status-badge { padding: 3px 10px; border-radius: 10px; font-size: 11px; color: #fff; font-weight: 600; }
    .status-draft { background: #1976d2; }
    .status-posted { background: #388e3c; }
    .status-cancelled { background: #d32f2f; }
    .loading, .empty-state { padding: 40px; text-align: center; color: #666; }
  `]
})
export class SalesInvoiceListComponent implements OnInit {
  private api = inject(ApiService);

  invoices = signal<SalesInvoice[]>([]);
  filteredInvoices = signal<SalesInvoice[]>([]);
  loading = signal(true);
  searchTerm = '';
  selectedStatus = '';

  ngOnInit(): void {
    this.loadInvoices();
  }

  loadInvoices(): void {
    this.loading.set(true);
    this.api.getAllSalesInvoices().subscribe({
      next: (data) => {
        this.invoices.set(data);
        this.filterInvoices();
        this.loading.set(false);
      },
      error: () => this.loading.set(false)
    });
  }

  filterInvoices(): void {
    let result = this.invoices();
    if (this.searchTerm) {
      const term = this.searchTerm.toLowerCase();
      result = result.filter(i =>
        i.invoiceNumber.toLowerCase().includes(term) ||
        (i.customer?.name ?? '').toLowerCase().includes(term)
      );
    }
    if (this.selectedStatus) {
      result = result.filter(i => i.status === this.selectedStatus);
    }
    this.filteredInvoices.set(result);
  }

  postInvoice(inv: SalesInvoice): void {
    if (confirm(`Post invoice ${inv.invoiceNumber}?`)) {
      this.api.postSalesInvoice(inv.id).subscribe(() => this.loadInvoices());
    }
  }

  deleteInvoice(inv: SalesInvoice): void {
    if (confirm(`Delete invoice ${inv.invoiceNumber}?`)) {
      this.api.deleteSalesInvoice(inv.id).subscribe(() => this.loadInvoices());
    }
  }
}
