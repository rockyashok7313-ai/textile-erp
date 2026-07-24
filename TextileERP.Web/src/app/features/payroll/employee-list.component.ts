import { Component, OnInit, inject, signal, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { ApiService } from '../../core/services/api.service';
import { Employee, Department } from '../../core/models';

@Component({
  selector: 'app-employee-list',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './employee-list.component.html',
  styleUrls: ['./employee-list.component.scss'],
})
export class EmployeeListComponent implements OnInit {
  private readonly api = inject(ApiService);
  private readonly router = inject(Router);

  employees = signal<Employee[]>([]);
  departments = signal<Department[]>([]);
  searchTerm = signal('');
  selectedDepartment = signal<number | null>(null);
  loading = signal(false);

  filteredEmployees = computed(() => {
    let list = this.employees();
    const term = this.searchTerm().toLowerCase();
    const deptId = this.selectedDepartment();

    if (term) {
      list = list.filter(
        (e) =>
          e.employeeCode.toLowerCase().includes(term) ||
          e.firstName.toLowerCase().includes(term) ||
          e.lastName.toLowerCase().includes(term)
      );
    }

    if (deptId) {
      list = list.filter((e) => e.departmentId === deptId);
    }

    return list;
  });

  ngOnInit(): void {
    this.loadEmployees();
    this.loadDepartments();
  }

  loadEmployees(): void {
    this.loading.set(true);
    this.api.getAllEmployees().subscribe({
      next: (data) => {
        this.employees.set(data);
        this.loading.set(false);
      },
      error: () => this.loading.set(false),
    });
  }

  loadDepartments(): void {
    this.api.getAllDepartments().subscribe({
      next: (data) => this.departments.set(data),
    });
  }

  onSearch(event: Event): void {
    this.searchTerm.set((event.target as HTMLInputElement).value);
  }

  onDepartmentFilter(event: Event): void {
    const val = (event.target as HTMLSelectElement).value;
    this.selectedDepartment.set(val ? +val : null);
  }

  navigateToCreate(): void {
    this.router.navigate(['/payroll/employees/new']);
  }

  editEmployee(id: number): void {
    this.router.navigate(['/payroll/employees', id, 'edit']);
  }

  deleteEmployee(employee: Employee): void {
    if (confirm(`Delete employee ${employee.firstName} ${employee.lastName}?`)) {
      this.api.deleteEmployee(employee.id).subscribe({
        next: () => this.loadEmployees(),
      });
    }
  }

  getDepartmentName(deptId: number): string {
    const dept = this.departments().find((d) => d.id === deptId);
    return dept?.name ?? '-';
  }
}
