import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ApiService } from '../../core/services/api.service';
import { Employee, Department, Designation } from '../../core/models';

@Component({
  selector: 'app-employee-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './employee-form.component.html',
  styleUrls: ['./employee-form.component.scss'],
})
export class EmployeeFormComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly api = inject(ApiService);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);

  form!: FormGroup;
  departments = signal<Department[]>([]);
  designations = signal<Designation[]>([]);
  isEdit = signal(false);
  employeeId = signal<number | null>(null);
  saving = signal(false);

  ngOnInit(): void {
    this.initForm();
    this.loadDepartments();
    this.loadDesignations();

    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEdit.set(true);
      this.employeeId.set(+id);
      this.loadEmployee(+id);
    }
  }

  private initForm(): void {
    this.form = this.fb.group({
      employeeCode: ['', Validators.required],
      firstName: ['', Validators.required],
      lastName: ['', Validators.required],
      dateOfBirth: [''],
      dateOfJoining: ['', Validators.required],
      gender: [''],
      maritalStatus: [''],
      bloodGroup: [''],
      personalEmail: [''],
      companyEmail: [''],
      phone: [''],
      mobile: [''],
      address: [''],
      city: [''],
      pincode: [''],
      emergencyContactName: [''],
      emergencyContactPhone: [''],
      departmentId: [null, Validators.required],
      designationId: [null, Validators.required],
      reportingToId: [null],
      bankAccountNumber: [''],
      bankName: [''],
      ifscCode: [''],
      panNumber: [''],
      aadhaarNumber: [''],
      pfNumber: [''],
      esiNumber: [''],
      uanNumber: [''],
      basicSalary: [null],
      grossSalary: [null],
      isProbationary: [false],
      probationEndDate: [''],
      isActive: [true],
    });
  }

  loadDepartments(): void {
    this.api.getAllDepartments().subscribe({
      next: (data) => this.departments.set(data),
    });
  }

  loadDesignations(): void {
    this.api.getAllDesignations().subscribe({
      next: (data) => this.designations.set(data),
    });
  }

  loadEmployee(id: number): void {
    this.api.getEmployeeById(id).subscribe({
      next: (emp) => {
        this.form.patchValue({
          employeeCode: emp.employeeCode,
          firstName: emp.firstName,
          lastName: emp.lastName,
          dateOfBirth: emp.dateOfBirth ? emp.dateOfBirth.toString().split('T')[0] : '',
          dateOfJoining: emp.dateOfJoining ? emp.dateOfJoining.toString().split('T')[0] : '',
          gender: emp.gender ?? '',
          maritalStatus: emp.maritalStatus ?? '',
          bloodGroup: emp.bloodGroup ?? '',
          personalEmail: emp.personalEmail ?? '',
          companyEmail: emp.companyEmail ?? '',
          phone: emp.phone ?? '',
          mobile: emp.mobile ?? '',
          address: emp.address ?? '',
          city: emp.city ?? '',
          pincode: emp.pincode ?? '',
          emergencyContactName: emp.emergencyContactName ?? '',
          emergencyContactPhone: emp.emergencyContactPhone ?? '',
          departmentId: emp.departmentId,
          designationId: emp.designationId,
          reportingToId: emp.reportingToId ?? null,
          bankAccountNumber: emp.bankAccountNumber ?? '',
          bankName: emp.bankName ?? '',
          ifscCode: emp.ifscCode ?? '',
          panNumber: emp.panNumber ?? '',
          aadhaarNumber: emp.aadhaarNumber ?? '',
          pfNumber: emp.pfNumber ?? '',
          esiNumber: emp.esiNumber ?? '',
          uanNumber: emp.uanNumber ?? '',
          basicSalary: emp.basicSalary ?? null,
          grossSalary: emp.grossSalary ?? null,
          isProbationary: emp.isProbationary,
          probationEndDate: emp.probationEndDate ? emp.probationEndDate.toString().split('T')[0] : '',
          isActive: emp.isActive,
        });
      },
    });
  }

  onSubmit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    this.saving.set(true);
    const value = this.form.value;

    const request$ = this.isEdit()
      ? this.api.updateEmployee(this.employeeId()!, value)
      : this.api.createEmployee(value);

    request$.subscribe({
      next: () => {
        this.saving.set(false);
        this.router.navigate(['/payroll/employees']);
      },
      error: () => this.saving.set(false),
    });
  }

  onCancel(): void {
    this.router.navigate(['/payroll/employees']);
  }
}
