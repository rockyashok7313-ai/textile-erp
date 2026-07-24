import { Component, OnInit, inject, signal, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { Item } from '../../../core/models';

@Component({
  selector: 'app-item-list',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  template: `
    <div class="page-header">
      <h2>Items</h2>
      <div class="actions">
        <input type="text" class="search-box" placeholder="Search items..." [(ngModel)]="searchTerm" (ngModelChange)="filterItems()" />
        <select class="filter-select" [(ngModel)]="selectedCategory" (ngModelChange)="filterItems()">
          <option value="">All Categories</option>
        </select>
        <button class="btn btn-primary" routerLink="new">+ New Item</button>
      </div>
    </div>

    @if (loading()) {
      <div class="loading">Loading items...</div>
    } @else if (filteredItems().length === 0) {
      <div class="empty-state">No items found.</div>
    } @else {
      <table class="data-table">
        <thead>
          <tr>
            <th>Item Code</th>
            <th>Item Name</th>
            <th>HSN Code</th>
            <th>GST Rate</th>
            <th>Purchase Rate</th>
            <th>Sales Rate</th>
            <th>Stock</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          @for (item of filteredItems(); track item.id) {
            <tr [class.low-stock]="isLowStock(item)">
              <td>{{ item.code }}</td>
              <td>{{ item.name }}</td>
              <td>{{ item.hsnCode }}</td>
              <td>{{ item.gstRate?.rate }}%</td>
              <td>{{ item.purchaseRate | number:'1.2-2' }}</td>
              <td>{{ item.sellingRate | number:'1.2-2' }}</td>
              <td>
                <span [class.stock-warning]="isLowStock(item)">{{ item.currentStock ?? 0 }}</span>
                @if (isLowStock(item)) {
                  <span class="low-stock-badge">Low</span>
                }
              </td>
              <td class="action-cell">
                <button class="btn btn-sm btn-info" [routerLink]="['edit', item.id]">Edit</button>
                <button class="btn btn-sm btn-danger" (click)="deleteItem(item)">Delete</button>
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
    .search-box { padding: 6px 12px; border: 1px solid #ccc; border-radius: 4px; min-width: 200px; }
    .filter-select { padding: 6px 12px; border: 1px solid #ccc; border-radius: 4px; }
    .btn { padding: 6px 14px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }
    .btn-primary { background: #1976d2; color: #fff; }
    .btn-sm { padding: 4px 10px; font-size: 12px; }
    .btn-info { background: #0288d1; color: #fff; }
    .btn-danger { background: #d32f2f; color: #fff; }
    .data-table { width: 100%; border-collapse: collapse; background: #fff; }
    .data-table th, .data-table td { padding: 10px 12px; border: 1px solid #e0e0e0; text-align: left; }
    .data-table th { background: #f5f5f5; font-weight: 600; }
    .data-table tr:hover { background: #f9f9f9; }
    .low-stock { background: #fff3e0 !important; }
    .stock-warning { color: #d32f2f; font-weight: 600; }
    .low-stock-badge { background: #ff9800; color: #fff; font-size: 10px; padding: 2px 6px; border-radius: 8px; margin-left: 6px; }
    .action-cell { white-space: nowrap; display: flex; gap: 4px; }
    .loading, .empty-state { padding: 40px; text-align: center; color: #666; }
  `]
})
export class ItemListComponent implements OnInit {
  private api = inject(ApiService);

  items = signal<Item[]>([]);
  filteredItems = signal<Item[]>([]);
  loading = signal(true);
  searchTerm = '';
  selectedCategory = '';

  ngOnInit(): void {
    this.loadItems();
  }

  loadItems(): void {
    this.loading.set(true);
    this.api.getAllItems().subscribe({
      next: (data) => {
        this.items.set(data);
        this.filterItems();
        this.loading.set(false);
      },
      error: () => this.loading.set(false)
    });
  }

  filterItems(): void {
    let result = this.items();
    if (this.searchTerm) {
      const term = this.searchTerm.toLowerCase();
      result = result.filter(i =>
        i.code.toLowerCase().includes(term) ||
        i.name.toLowerCase().includes(term) ||
        (i.hsnCode ?? '').toLowerCase().includes(term)
      );
    }
    this.filteredItems.set(result);
  }

  isLowStock(item: Item): boolean {
    return (item.currentStock ?? 0) <= (item.reorderLevel ?? 0) && (item.reorderLevel ?? 0) > 0;
  }

  deleteItem(item: Item): void {
    if (confirm(`Delete item "${item.name}"?`)) {
      this.api.deleteItem(item.id).subscribe(() => this.loadItems());
    }
  }
}
