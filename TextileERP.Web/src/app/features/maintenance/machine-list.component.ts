import { Component, OnInit, inject, signal, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { ApiService } from '../../core/services/api.service';
import { Machine } from '../../core/models';

@Component({
  selector: 'app-machine-list',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './machine-list.component.html',
  styleUrls: ['./machine-list.component.scss'],
})
export class MachineListComponent implements OnInit {
  private readonly api = inject(ApiService);
  private readonly router = inject(Router);

  machines = signal<Machine[]>([]);
  loading = signal(false);
  typeFilter = signal('');
  statusFilter = signal('');

  filteredMachines = computed(() => {
    let list = this.machines();
    const type = this.typeFilter();
    const status = this.statusFilter();

    if (type) {
      list = list.filter((m) => m.machineType === type);
    }
    if (status) {
      list = list.filter((m) => m.status === status);
    }
    return list;
  });

  ngOnInit(): void {
    this.loadMachines();
  }

  loadMachines(): void {
    this.loading.set(true);
    this.api.getAllMachines().subscribe({
      next: (data) => {
        this.machines.set(data);
        this.loading.set(false);
      },
      error: () => this.loading.set(false),
    });
  }

  onTypeFilter(event: Event): void {
    this.typeFilter.set((event.target as HTMLSelectElement).value);
  }

  onStatusFilter(event: Event): void {
    this.statusFilter.set((event.target as HTMLSelectElement).value);
  }

  navigateToCreate(): void {
    this.router.navigate(['/maintenance/machines/new']);
  }

  editMachine(id: number): void {
    this.router.navigate(['/maintenance/machines', id, 'edit']);
  }

  deleteMachine(machine: Machine): void {
    if (confirm(`Delete machine ${machine.name}?`)) {
      this.api.deleteMachine(machine.id).subscribe({
        next: () => this.loadMachines(),
      });
    }
  }

  getStatusClass(status: string): string {
    switch (status) {
      case 'Running': return 'status-running';
      case 'Down': return 'status-down';
      case 'Maintenance': return 'status-maintenance';
      default: return 'status-idle';
    }
  }
}
