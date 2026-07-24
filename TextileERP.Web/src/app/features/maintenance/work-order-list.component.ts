import { Component, OnInit, inject, signal, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { ApiService } from '../../core/services/api.service';
import { WorkOrder } from '../../core/models';

@Component({
  selector: 'app-work-order-list',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './work-order-list.component.html',
  styleUrls: ['./work-order-list.component.scss'],
})
export class WorkOrderListComponent implements OnInit {
  private readonly api = inject(ApiService);
  private readonly router = inject(Router);

  workOrders = signal<WorkOrder[]>([]);
  loading = signal(false);
  statusFilter = signal('');

  completeModalOpen = signal(false);
  cancelModalOpen = signal(false);
  selectedOrder = signal<WorkOrder | null>(null);
  completionNotes = signal('');
  cancelReason = signal('');

  filteredOrders = computed(() => {
    const status = this.statusFilter();
    if (status) {
      return this.workOrders().filter((wo) => wo.status === status);
    }
    return this.workOrders();
  });

  ngOnInit(): void {
    this.loadWorkOrders();
  }

  loadWorkOrders(): void {
    this.loading.set(true);
    this.api.getAllWorkOrders().subscribe({
      next: (data) => {
        this.workOrders.set(data);
        this.loading.set(false);
      },
      error: () => this.loading.set(false),
    });
  }

  onStatusFilter(event: Event): void {
    this.statusFilter.set((event.target as HTMLSelectElement).value);
  }

  navigateToCreate(): void {
    this.router.navigate(['/maintenance/work-orders/new']);
  }

  openCompleteModal(order: WorkOrder): void {
    this.selectedOrder.set(order);
    this.completionNotes.set('');
    this.completeModalOpen.set(true);
  }

  openCancelModal(order: WorkOrder): void {
    this.selectedOrder.set(order);
    this.cancelReason.set('');
    this.cancelModalOpen.set(true);
  }

  completeOrder(): void {
    const order = this.selectedOrder();
    if (!order) return;

    this.api.completeWorkOrder(order.id, this.completionNotes() || undefined).subscribe({
      next: () => {
        this.completeModalOpen.set(false);
        this.loadWorkOrders();
      },
    });
  }

  cancelOrder(): void {
    const order = this.selectedOrder();
    if (!order) return;

    this.api.cancelWorkOrder(order.id, this.cancelReason() || undefined).subscribe({
      next: () => {
        this.cancelModalOpen.set(false);
        this.loadWorkOrders();
      },
    });
  }

  closeModal(): void {
    this.completeModalOpen.set(false);
    this.cancelModalOpen.set(false);
  }

  getStatusClass(status: string): string {
    switch (status) {
      case 'Created': return 'status-created';
      case 'InProgress': return 'status-inprogress';
      case 'Completed': return 'status-completed';
      case 'Cancelled': return 'status-cancelled';
      default: return '';
    }
  }
}
