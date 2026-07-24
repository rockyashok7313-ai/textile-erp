import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ApiService } from '../../core/services/api.service';
import { Machine } from '../../core/models';

@Component({
  selector: 'app-machine-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './machine-form.component.html',
  styleUrls: ['./machine-form.component.scss'],
})
export class MachineFormComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly api = inject(ApiService);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);

  form!: FormGroup;
  isEdit = signal(false);
  machineId = signal<number | null>(null);
  saving = signal(false);

  machineTypes = ['AirJet', 'Sulzer', 'Rapier', 'Projectile', 'Circular', 'Flat', 'Other'];
  statusOptions = ['Running', 'Down', 'Maintenance', 'Idle', 'Decommissioned'];

  ngOnInit(): void {
    this.initForm();

    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEdit.set(true);
      this.machineId.set(+id);
      this.loadMachine(+id);
    }
  }

  private initForm(): void {
    this.form = this.fb.group({
      code: ['', Validators.required],
      name: ['', Validators.required],
      description: [''],
      machineType: ['', Validators.required],
      manufacturer: [''],
      model: [''],
      serialNumber: [''],
      purchaseDate: [''],
      purchasePrice: [null],
      warrantyExpiryDate: [''],
      status: ['Idle', Validators.required],
      isOperational: [true],
      totalRunningHours: [null],
      lastMaintenanceDate: [''],
      nextMaintenanceDate: [''],
      isActive: [true],
    });
  }

  loadMachine(id: number): void {
    this.api.getMachineById(id).subscribe({
      next: (m) => {
        this.form.patchValue({
          code: m.code,
          name: m.name,
          description: m.description ?? '',
          machineType: m.machineType,
          manufacturer: m.manufacturer ?? '',
          model: m.model ?? '',
          serialNumber: m.serialNumber ?? '',
          purchaseDate: m.purchaseDate ? m.purchaseDate.toString().split('T')[0] : '',
          purchasePrice: m.purchasePrice ?? null,
          warrantyExpiryDate: m.warrantyExpiryDate ? m.warrantyExpiryDate.toString().split('T')[0] : '',
          status: m.status,
          isOperational: m.isOperational,
          totalRunningHours: m.totalRunningHours ?? null,
          lastMaintenanceDate: m.lastMaintenanceDate ? m.lastMaintenanceDate.toString().split('T')[0] : '',
          nextMaintenanceDate: m.nextMaintenanceDate ? m.nextMaintenanceDate.toString().split('T')[0] : '',
          isActive: m.isActive,
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
      ? this.api.updateMachine(this.machineId()!, value)
      : this.api.createMachine(value);

    request$.subscribe({
      next: () => {
        this.saving.set(false);
        this.router.navigate(['/maintenance/machines']);
      },
      error: () => this.saving.set(false),
    });
  }

  onCancel(): void {
    this.router.navigate(['/maintenance/machines']);
  }
}
