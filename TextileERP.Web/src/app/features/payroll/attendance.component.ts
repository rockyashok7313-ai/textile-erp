import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../core/services/api.service';
import { Employee, Attendance } from '../../core/models';

@Component({
  selector: 'app-attendance',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './attendance.component.html',
  styleUrls: ['./attendance.component.scss'],
})
export class AttendanceComponent implements OnInit {
  private readonly api = inject(ApiService);

  employees = signal<Employee[]>([]);
  attendanceList = signal<Attendance[]>([]);
  summary = signal<Record<string, unknown> | null>(null);

  selectedEmployeeId = signal<number | null>(null);
  selectedDate = signal<string>(new Date().toISOString().split('T')[0]);
  attendanceStatus = signal('Present');
  remarks = signal('');
  loading = signal(false);
  saving = signal(false);
  showSummary = signal(false);

  statusOptions = ['Present', 'Absent', 'HalfDay', 'Leave'];

  ngOnInit(): void {
    this.loadEmployees();
  }

  loadEmployees(): void {
    this.api.getActiveEmployees().subscribe({
      next: (data) => this.employees.set(data),
    });
  }

  loadAttendance(): void {
    const date = this.selectedDate();
    if (!date) return;

    this.loading.set(true);
    this.api.getAttendanceByDate(date).subscribe({
      next: (data) => {
        this.attendanceList.set(data);
        this.loading.set(false);
      },
      error: () => this.loading.set(false),
    });
  }

  markAttendance(): void {
    const empId = this.selectedEmployeeId();
    const date = this.selectedDate();
    if (!empId || !date) return;

    this.saving.set(true);
    const status = this.attendanceStatus();
    const payload: Partial<Attendance> = {
      employeeId: empId,
      attendanceDate: new Date(date),
      status,
      isHalfDay: status === 'HalfDay',
      isOnLeave: status === 'Leave',
      remarks: this.remarks() || undefined,
    };

    this.api.createAttendance(payload).subscribe({
      next: () => {
        this.saving.set(false);
        this.remarks.set('');
        this.loadAttendance();
      },
      error: () => this.saving.set(false),
    });
  }

  loadSummary(): void {
    const empId = this.selectedEmployeeId();
    if (!empId) return;

    const today = new Date();
    const startDate = new Date(today.getFullYear(), today.getMonth(), 1).toISOString().split('T')[0];
    const endDate = today.toISOString().split('T')[0];

    this.api.getAttendanceSummary(empId, startDate, endDate).subscribe({
      next: (data) => {
        this.summary.set(data);
        this.showSummary.set(true);
      },
    });
  }

  getStatusClass(status: string): string {
    switch (status) {
      case 'Present': return 'status-present';
      case 'Absent': return 'status-absent';
      case 'HalfDay': return 'status-halfday';
      case 'Leave': return 'status-leave';
      default: return '';
    }
  }

  getEmployeeName(empId: number): string {
    const emp = this.employees().find((e) => e.id === empId);
    return emp ? `${emp.firstName} ${emp.lastName}` : '-';
  }
}
