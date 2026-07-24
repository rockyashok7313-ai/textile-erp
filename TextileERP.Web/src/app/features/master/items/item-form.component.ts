import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { Item, ItemCategory, Unit, GSTRate } from '../../../core/models';

@Component({
  selector: 'app-item-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  template: `
    <div class="form-page">
      <h2>{{ isEdit() ? 'Edit Item' : 'New Item' }}</h2>

      @if (loading()) {
        <div class="loading">Loading...</div>
      } @else {
        <form [formGroup]="form" (ngSubmit)="onSubmit()">
          <div class="form-section">
            <h3>Basic Info</h3>
            <div class="form-grid">
              <div class="form-group">
                <label>Item Code *</label>
                <input formControlName="code" class="form-control" />
              </div>
              <div class="form-group">
                <label>Item Name *</label>
                <input formControlName="name" class="form-control" />
              </div>
              <div class="form-group">
                <label>Description</label>
                <input formControlName="description" class="form-control" />
              </div>
              <div class="form-group">
                <label>Barcode</label>
                <input formControlName="barcode" class="form-control" />
              </div>
              <div class="form-group">
                <label>Category *</label>
                <select formControlName="categoryId" class="form-control">
                  <option value="">Select</option>
                  @for (cat of categories(); track cat.id) {
                    <option [value]="cat.id">{{ cat.name }}</option>
                  }
                </select>
              </div>
              <div class="form-group">
                <label>Unit *</label>
                <select formControlName="unitId" class="form-control">
                  <option value="">Select</option>
                  @for (u of units(); track u.id) {
                    <option [value]="u.id">{{ u.name }}</option>
                  }
                </select>
              </div>
            </div>
          </div>

          <div class="form-section">
            <h3>Textile Fields</h3>
            <div class="form-grid">
              <div class="form-group">
                <label>GSM</label>
                <input type="number" formControlName="gsm" class="form-control" />
              </div>
              <div class="form-group">
                <label>Width</label>
                <input type="number" formControlName="width" class="form-control" />
              </div>
              <div class="form-group">
                <label>Fiber Content</label>
                <input formControlName="fiberContent" class="form-control" />
              </div>
              <div class="form-group">
                <label>Construction</label>
                <input formControlName="construction" class="form-control" />
              </div>
              <div class="form-group">
                <label>Color</label>
                <input formControlName="color" class="form-control" />
              </div>
              <div class="form-group">
                <label>Shade</label>
                <input formControlName="shade" class="form-control" />
              </div>
            </div>
          </div>

          <div class="form-section">
            <h3>GST &amp; Pricing</h3>
            <div class="form-grid">
              <div class="form-group">
                <label>HSN Code</label>
                <input formControlName="hsnCode" class="form-control" />
              </div>
              <div class="form-group">
                <label>GST Rate *</label>
                <select formControlName="gstRateId" class="form-control">
                  <option value="">Select</option>
                  @for (r of gstRates(); track r.id) {
                    <option [value]="r.id">{{ r.rate }}%</option>
                  }
                </select>
              </div>
              <div class="form-group">
                <label>Purchase Rate</label>
                <input type="number" step="0.01" formControlName="purchaseRate" class="form-control" />
              </div>
              <div class="form-group">
                <label>Selling Rate</label>
                <input type="number" step="0.01" formControlName="sellingRate" class="form-control" />
              </div>
              <div class="form-group">
                <label>MRP</label>
                <input type="number" step="0.01" formControlName="mrp" class="form-control" />
              </div>
              <div class="form-group">
                <label>Reorder Level</label>
                <input type="number" formControlName="reorderLevel" class="form-control" />
              </div>
            </div>
          </div>

          <div class="form-actions">
            <button type="submit" class="btn btn-primary" [disabled]="form.invalid || saving()">
              {{ saving() ? 'Saving...' : 'Save' }}
            </button>
            <button type="button" class="btn btn-secondary" routerLink="/master/items">Cancel</button>
          </div>
        </form>
      }
    </div>
  `,
  styles: [`
    .form-page { max-width: 900px; }
    .form-page h2 { margin-bottom: 16px; }
    .form-section { background: #fff; border: 1px solid #e0e0e0; border-radius: 6px; padding: 16px; margin-bottom: 16px; }
    .form-section h3 { margin: 0 0 12px 0; font-size: 15px; color: #333; }
    .form-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 12px; }
    .form-group { display: flex; flex-direction: column; }
    .form-group label { font-size: 13px; margin-bottom: 4px; color: #555; }
    .form-control { padding: 6px 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
    .form-control.ng-invalid.ng-touched { border-color: #d32f2f; }
    .form-actions { display: flex; gap: 8px; }
    .btn { padding: 8px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
    .btn-primary { background: #1976d2; color: #fff; }
    .btn-secondary { background: #e0e0e0; color: #333; }
    .btn:disabled { opacity: 0.6; cursor: not-allowed; }
    .loading { padding: 40px; text-align: center; color: #666; }
  `]
})
export class ItemFormComponent implements OnInit {
  private fb = inject(FormBuilder);
  private api = inject(ApiService);
  private route = inject(ActivatedRoute);
  private router = inject(Router);

  form: FormGroup = this.fb.group({
    code: ['', Validators.required],
    name: ['', Validators.required],
    description: [''],
    barcode: [''],
    categoryId: ['', Validators.required],
    unitId: ['', Validators.required],
    gsm: [null],
    width: [null],
    fiberContent: [''],
    construction: [''],
    color: [''],
    shade: [''],
    hsnCode: [''],
    gstRateId: ['', Validators.required],
    purchaseRate: [null],
    sellingRate: [null],
    mrp: [null],
    reorderLevel: [null],
    isActive: [true]
  });

  isEdit = signal(false);
  loading = signal(false);
  saving = signal(false);
  categories = signal<ItemCategory[]>([]);
  units = signal<Unit[]>([]);
  gstRates = signal<GSTRate[]>([]);

  ngOnInit(): void {
    this.loadDropdowns();
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEdit.set(true);
      this.loadItem(+id);
    }
  }

  loadDropdowns(): void {
    this.api.getAllItemCategories().subscribe(c => this.categories.set(c));
    this.api.getAllUnits().subscribe(u => this.units.set(u));
    this.api.getAllGSTRates().subscribe(r => this.gstRates.set(r));
  }

  loadItem(id: number): void {
    this.loading.set(true);
    this.api.getItemById(id).subscribe({
      next: (item) => {
        this.form.patchValue({
          code: item.code,
          name: item.name,
          description: item.description,
          barcode: item.barcode,
          categoryId: item.categoryId,
          unitId: item.unitId,
          hsnCode: item.hsnCode,
          gstRateId: item.gstRateId,
          purchaseRate: item.purchaseRate,
          sellingRate: item.sellingRate,
          mrp: item.mrp,
          reorderLevel: item.reorderLevel,
          isActive: item.isActive
        });
        this.loading.set(false);
      },
      error: () => this.loading.set(false)
    });
  }

  onSubmit(): void {
    if (this.form.invalid) return;
    this.saving.set(true);
    const data = this.form.value;
    const id = this.route.snapshot.paramMap.get('id');

    const request = id
      ? this.api.updateItem(+id, data)
      : this.api.createItem(data);

    request.subscribe({
      next: () => {
        this.saving.set(false);
        this.router.navigate(['/master/items']);
      },
      error: () => this.saving.set(false)
    });
  }
}
