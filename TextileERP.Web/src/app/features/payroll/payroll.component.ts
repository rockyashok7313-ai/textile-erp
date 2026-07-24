import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../core/services/api.service';
import { PayrollHeader, PayrollPeriod } from '../../core/models';

@Component({
  selector: 'app-payroll',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './payroll.component.html',
  styleUrls: ['./payroll.component.scss'],
})
export class PayrollComponent implements OnInit {
  private readonly api = inject(ApiService);

  periods = signal<PayrollPeriod[]>([]);
  payrollList = signal<PayrollHeader[]>([]);
  selectedPeriodId = signal<number | null>(null);
  loading = signal(false);
  processing = signal(false);
  statusFilter = signal('');

  filteredPayroll = signal<PayrollHeader[]>([]);

  ngOnInit(): void {
    this.loadPeriods();
    this.loadPayroll();
  }

  loadPeriods(): void {
    this.api.getAllPayrollPeriods().subscribe({
      next: (data) => this.periods.set(data),
    });
  }

  loadPayroll(): void {
    this.loading.set(true);
    this.api.getAllPayrolls().subscribe({
      next: (data) => {
        this.payrollList.set(data);
        this.applyFilter();
        this.loading.set(false);
      },
      error: () => this.loading.set(false),
    });
  }

  processPayroll(): void {
    const periodId = this.selectedPeriodId();
    if (!periodId) return;

    if (!confirm('Process payroll for the selected period?')) return;

    this.processing.set(true);
    this.api.processPayroll(periodId).subscribe({
      next: () => {
        this.processing.set(false);
        this.loadPayroll();
      },
      error: () => this.processing.set(false),
    });
  }

  approvePayroll(item: PayrollHeader): void {
    if (!confirm(`Approve payroll for ${item.employee?.firstName ?? 'employee'}?`)) return;

    this.api.approvePayroll(item.id).subscribe({
      next: () => this.loadPayroll(),
    });
  }

  cancelPayroll(item: PayrollHeader): void {
    if (!confirm(`Cancel payroll for ${item.employee?.firstName ?? 'employee'}?`)) return;

    this.api.cancelPayroll(item.id).subscribe({
      next: () => this.loadPayroll(),
    });
  }

  onStatusFilter(event: Event): void {
    this.statusFilter.set((event.target as HTMLSelectElement).value);
    this.applyFilter();
  }

  applyFilter(): void {
    const status = this.statusFilter();
    let list = this.payrollList();
    if (status) {
      list = list.filter((p) => p.status === status);
    }
    this.filteredPayroll.set(list);
  }

  getStatusClass(status: string): string {
    switch (status) {
      case 'Processed': return 'status-processed';
      case 'Approved': return 'status-approved';
      case 'Paid': return 'status-paid';
      case 'Cancelled': return 'status-cancelled';
      default: return 'status-draft';
    }
  }
}
