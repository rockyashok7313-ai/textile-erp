import { Component, OnInit, inject, signal, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { ApiService } from '../../core/services/api.service';
import { SparePart, ItemCategory } from '../../core/models';

@Component({
  selector: 'app-spare-part-list',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './spare-part-list.component.html',
  styleUrls: ['./spare-part-list.component.scss'],
})
export class SparePartListComponent implements OnInit {
  private readonly api = inject(ApiService);
  private readonly router = inject(Router);

  spareParts = signal<SparePart[]>([]);
  categories = signal<ItemCategory[]>([]);
  loading = signal(false);
  categoryFilter = signal<number | null>(null);

  consumeModalOpen = signal(false);
  restockModalOpen = signal(false);
  selectedPart = signal<SparePart | null>(null);
  transactionQuantity = signal(0);

  filteredParts = computed(() => {
    const catId = this.categoryFilter();
    if (catId) {
      return this.spareParts().filter((sp) => sp.categoryId === catId);
    }
    return this.spareParts();
  });

  ngOnInit(): void {
    this.loadSpareParts();
    this.loadCategories();
  }

  loadSpareParts(): void {
    this.loading.set(true);
    this.api.getAllSpareParts().subscribe({
      next: (data) => {
        this.spareParts.set(data);
        this.loading.set(false);
      },
      error: () => this.loading.set(false),
    });
  }

  loadCategories(): void {
    this.api.getAllItemCategories().subscribe({
      next: (data) => this.categories.set(data),
    });
  }

  onCategoryFilter(event: Event): void {
    const val = (event.target as HTMLSelectElement).value;
    this.categoryFilter.set(val ? +val : null);
  }

  isLowStock(part: SparePart): boolean {
    const stock = part.currentStock ?? 0;
    const reorder = part.reorderLevel ?? 0;
    return reorder > 0 && stock <= reorder;
  }

  openConsumeModal(part: SparePart): void {
    this.selectedPart.set(part);
    this.transactionQuantity.set(0);
    this.consumeModalOpen.set(true);
  }

  openRestockModal(part: SparePart): void {
    this.selectedPart.set(part);
    this.transactionQuantity.set(0);
    this.restockModalOpen.set(true);
  }

  consumeStock(): void {
    const part = this.selectedPart();
    if (!part || this.transactionQuantity() <= 0) return;

    this.api.consumeSparePart(part.id, this.transactionQuantity()).subscribe({
      next: () => {
        this.consumeModalOpen.set(false);
        this.loadSpareParts();
      },
    });
  }

  restockPart(): void {
    const part = this.selectedPart();
    if (!part || this.transactionQuantity() <= 0) return;

    this.api.restockSparePart(part.id, this.transactionQuantity()).subscribe({
      next: () => {
        this.restockModalOpen.set(false);
        this.loadSpareParts();
      },
    });
  }

  navigateToCreate(): void {
    this.router.navigate(['/maintenance/spare-parts/new']);
  }

  closeModal(): void {
    this.consumeModalOpen.set(false);
    this.restockModalOpen.set(false);
  }
}
