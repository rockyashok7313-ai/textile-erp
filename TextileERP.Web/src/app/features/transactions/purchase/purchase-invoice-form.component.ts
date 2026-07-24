import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators, FormArray } from '@angular/forms';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { Party, Item } from '../../../core/models';

@Component({
  selector: 'app-purchase-invoice-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  template: `
    <div class="form-page">
      <h2>{{ isEdit() ? 'Edit Purchase Invoice' : 'New Purchase Invoice' }}</h2>

      @if (loading()) {
        <div class="loading">Loading...</div>
      } @else {
        <form [formGroup]="form" (ngSubmit)="onSubmit()">
          <div class="form-section">
            <h3>Header</h3>
            <div class="form-grid">
              <div class="form-group">
                <label>Invoice Number *</label>
                <input formControlName="invoiceNumber" class="form-control" />
              </div>
              <div class="form-group">
                <label>Supplier Invoice #</label>
                <input formControlName="supplierInvoiceNumber" class="form-control" />
              </div>
              <div class="form-group">
                <label>Invoice Date *</label>
                <input type="date" formControlName="invoiceDate" class="form-control" />
              </div>
              <div class="form-group">
                <label>Supplier *</label>
                <select formControlName="supplierId" class="form-control">
                  <option value="">Select Supplier</option>
                  @for (s of suppliers(); track s.id) {
                    <option [value]="s.id">{{ s.name }}</option>
                  }
                </select>
              </div>
              <div class="form-group">
                <label>Due Date</label>
                <input type="date" formControlName="dueDate" class="form-control" />
              </div>
              <div class="form-group">
                <label>Reference Number</label>
                <input formControlName="referenceNumber" class="form-control" />
              </div>
              <div class="form-group">
                <label>
                  <input type="checkbox" formControlName="isInterState" (change)="recalculateGST()" /> Inter-State
                </label>
              </div>
            </div>
          </div>

          <div class="form-section">
            <h3>Line Items</h3>
            <div formArrayName="details">
              @for (line of detailsArray.controls; track $index) {
                <div [formGroupName]="$index" class="line-item">
                  <div class="line-grid">
                    <div class="form-group">
                      <label>Item *</label>
                      <select formControlName="itemId" class="form-control" (change)="onItemSelect($index)">
                        <option value="">Select</option>
                        @for (item of items(); track item.id) {
                          <option [value]="item.id">{{ item.name }}</option>
                        }
                      </select>
                    </div>
                    <div class="form-group">
                      <label>Qty *</label>
                      <input type="number" step="0.01" formControlName="quantity" class="form-control" (input)="calcLineTotal($index)" />
                    </div>
                    <div class="form-group">
                      <label>Rate *</label>
                      <input type="number" step="0.01" formControlName="rate" class="form-control" (input)="calcLineTotal($index)" />
                    </div>
                    <div class="form-group">
                      <label>Discount %</label>
                      <input type="number" step="0.01" formControlName="discountPercent" class="form-control" (input)="calcLineTotal($index)" />
                    </div>
                    <div class="form-group">
                      <label>GST %</label>
                      <input type="number" step="0.01" formControlName="gstRate" class="form-control" (input)="calcLineTotal($index)" />
                    </div>
                    <div class="form-group">
                      <label>Amount</label>
                      <input type="number" step="0.01" formControlName="totalAmount" class="form-control" readonly />
                    </div>
                    <div class="form-group line-actions">
                      <label>&nbsp;</label>
                      <button type="button" class="btn btn-sm btn-danger" (click)="removeLine($index)">Remove</button>
                    </div>
                  </div>
                  <div class="tax-row">
                    <span>CGST: {{ line.get('cgstAmount')?.value | number:'1.2-2' }}</span>
                    <span>SGST: {{ line.get('sgstAmount')?.value | number:'1.2-2' }}</span>
                    <span>IGST: {{ line.get('igstAmount')?.value | number:'1.2-2' }}</span>
                  </div>
                </div>
              }
              <button type="button" class="btn btn-sm btn-secondary" (click)="addLine()">+ Add Line</button>
            </div>
          </div>

          <div class="form-section totals">
            <div class="totals-grid">
              <div>Total Gross: <strong>{{ totalGross() | number:'1.2-2' }}</strong></div>
              <div>Total Discount: <strong>{{ totalDiscount() | number:'1.2-2' }}</strong></div>
              <div>Total CGST: <strong>{{ totalCGST() | number:'1.2-2' }}</strong></div>
              <div>Total SGST: <strong>{{ totalSGST() | number:'1.2-2' }}</strong></div>
              <div>Total IGST: <strong>{{ totalIGST() | number:'1.2-2' }}</strong></div>
              <div class="grand-total">Grand Total: <strong>{{ grandTotal() | number:'1.2-2' }}</strong></div>
            </div>
          </div>

          <div class="form-group">
            <label>Notes</label>
            <textarea formControlName="notes" class="form-control" rows="2"></textarea>
          </div>

          <div class="form-actions">
            <button type="submit" class="btn btn-primary" [disabled]="form.invalid || saving()">
              {{ saving() ? 'Saving...' : 'Save' }}
            </button>
            <button type="button" class="btn btn-secondary" routerLink="/transactions/purchase">Cancel</button>
          </div>
        </form>
      }
    </div>
  `,
  styles: [`
    .form-page { max-width: 1100px; }
    .form-page h2 { margin-bottom: 16px; }
    .form-section { background: #fff; border: 1px solid #e0e0e0; border-radius: 6px; padding: 16px; margin-bottom: 16px; }
    .form-section h3 { margin: 0 0 12px 0; font-size: 15px; color: #333; }
    .form-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 12px; }
    .form-group { display: flex; flex-direction: column; }
    .form-group label { font-size: 13px; margin-bottom: 4px; color: #555; }
    .form-control { padding: 6px 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
    .line-item { border: 1px solid #e0e0e0; border-radius: 4px; padding: 10px; margin-bottom: 8px; }
    .line-grid { display: grid; grid-template-columns: 2fr repeat(4, 1fr) 1.2fr auto; gap: 8px; align-items: end; }
    .line-actions { justify-content: flex-end; }
    .tax-row { margin-top: 6px; font-size: 12px; color: #666; display: flex; gap: 16px; }
    .totals { display: flex; justify-content: flex-end; }
    .totals-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; min-width: 400px; text-align: right; }
    .grand-total { grid-column: span 3; font-size: 16px; border-top: 2px solid #333; padding-top: 8px; margin-top: 4px; }
    .form-actions { display: flex; gap: 8px; margin-top: 8px; }
    .btn { padding: 6px 14px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }
    .btn-primary { background: #1976d2; color: #fff; }
    .btn-secondary { background: #e0e0e0; color: #333; }
    .btn-danger { background: #d32f2f; color: #fff; }
    .btn:disabled { opacity: 0.6; cursor: not-allowed; }
    .loading { padding: 40px; text-align: center; color: #666; }
    textarea.form-control { resize: vertical; }
  `]
})
export class PurchaseInvoiceFormComponent implements OnInit {
  private fb = inject(FormBuilder);
  private api = inject(ApiService);
  private route = inject(ActivatedRoute);
  private router = inject(Router);

  form: FormGroup = this.fb.group({
    invoiceNumber: ['', Validators.required],
    supplierInvoiceNumber: [''],
    invoiceDate: [new Date().toISOString().substring(0, 10), Validators.required],
    supplierId: ['', Validators.required],
    dueDate: [''],
    referenceNumber: [''],
    isInterState: [false],
    notes: [''],
    details: this.fb.array([]),
    status: ['Draft']
  });

  isEdit = signal(false);
  loading = signal(false);
  saving = signal(false);
  suppliers = signal<Party[]>([]);
  items = signal<Item[]>([]);

  get detailsArray(): FormArray {
    return this.form.get('details') as FormArray;
  }

  ngOnInit(): void {
    this.api.getSuppliers().subscribe(s => this.suppliers.set(s));
    this.api.getAllItems().subscribe(i => this.items.set(i));
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEdit.set(true);
      this.loadInvoice(+id);
    } else {
      this.addLine();
    }
  }

  loadInvoice(id: number): void {
    this.loading.set(true);
    this.api.getPurchaseInvoiceById(id).subscribe({
      next: (inv) => {
        this.form.patchValue({
          invoiceNumber: inv.invoiceNumber,
          supplierInvoiceNumber: inv.supplierInvoiceNumber,
          invoiceDate: inv.invoiceDate?.toString().substring(0, 10),
          supplierId: inv.supplierId,
          dueDate: inv.dueDate?.toString().substring(0, 10),
          referenceNumber: inv.referenceNumber,
          isInterState: inv.isInterState,
          notes: inv.notes,
          status: inv.status
        });
        this.detailsArray.clear();
        inv.details?.forEach(d => {
          this.detailsArray.push(this.fb.group({
            itemId: [d.itemId, Validators.required],
            quantity: [d.quantity, Validators.required],
            rate: [d.rate, Validators.required],
            discountPercent: [d.discountPercent ?? 0],
            gstRate: [d.gstRate?.rate ?? 0],
            cgstRate: [d.cgstRate ?? 0],
            cgstAmount: [d.cgstAmount ?? 0],
            sgstRate: [d.sgstRate ?? 0],
            sgstAmount: [d.sgstAmount ?? 0],
            igstRate: [d.igstRate ?? 0],
            igstAmount: [d.igstAmount ?? 0],
            totalAmount: [d.totalAmount ?? 0]
          }));
        });
        this.loading.set(false);
      },
      error: () => this.loading.set(false)
    });
  }

  addLine(): void {
    this.detailsArray.push(this.fb.group({
      itemId: ['', Validators.required],
      quantity: [1, Validators.required],
      rate: [0, Validators.required],
      discountPercent: [0],
      gstRate: [0],
      cgstRate: [0],
      cgstAmount: [0],
      sgstRate: [0],
      sgstAmount: [0],
      igstRate: [0],
      igstAmount: [0],
      totalAmount: [0]
    }));
  }

  removeLine(index: number): void {
    this.detailsArray.removeAt(index);
  }

  onItemSelect(index: number): void {
    const line = this.detailsArray.at(index);
    const itemId = +line.get('itemId')?.value;
    const item = this.items().find(i => i.id === itemId);
    if (item) {
      line.patchValue({ rate: item.purchaseRate ?? 0, gstRate: item.gstRate?.rate ?? 0 });
      this.calcLineTotal(index);
    }
  }

  calcLineTotal(index: number): void {
    const line = this.detailsArray.at(index);
    const qty = +line.get('quantity')?.value || 0;
    const rate = +line.get('rate')?.value || 0;
    const disc = +line.get('discountPercent')?.value || 0;
    const gstRate = +line.get('gstRate')?.value || 0;
    const isInter = this.form.get('isInterState')?.value;

    const gross = qty * rate;
    const discountAmt = gross * disc / 100;
    const taxable = gross - discountAmt;
    const cgstRate = isInter ? 0 : gstRate / 2;
    const sgstRate = isInter ? 0 : gstRate / 2;
    const igstRate = isInter ? gstRate : 0;
    const cgstAmt = taxable * cgstRate / 100;
    const sgstAmt = taxable * sgstRate / 100;
    const igstAmt = taxable * igstRate / 100;

    line.patchValue({
      cgstRate, cgstAmount: cgstAmt, sgstRate, sgstAmount: sgstAmt,
      igstRate, igstAmount: igstAmt, totalAmount: taxable + cgstAmt + sgstAmt + igstAmt
    });
  }

  recalculateGST(): void {
    this.detailsArray.controls.forEach((_, i) => this.calcLineTotal(i));
  }

  totalGross(): number {
    return this.detailsArray.controls.reduce((s, c) => s + (+c.get('quantity')?.value || 0) * (+c.get('rate')?.value || 0), 0);
  }

  totalDiscount(): number {
    return this.detailsArray.controls.reduce((s, c) => {
      const gross = (+c.get('quantity')?.value || 0) * (+c.get('rate')?.value || 0);
      return s + gross * (+c.get('discountPercent')?.value || 0) / 100;
    }, 0);
  }

  totalCGST(): number {
    return this.detailsArray.controls.reduce((s, c) => s + (+c.get('cgstAmount')?.value || 0), 0);
  }

  totalSGST(): number {
    return this.detailsArray.controls.reduce((s, c) => s + (+c.get('sgstAmount')?.value || 0), 0);
  }

  totalIGST(): number {
    return this.detailsArray.controls.reduce((s, c) => s + (+c.get('igstAmount')?.value || 0), 0);
  }

  grandTotal(): number {
    return this.detailsArray.controls.reduce((s, c) => s + (+c.get('totalAmount')?.value || 0), 0);
  }

  onSubmit(): void {
    if (this.form.invalid) return;
    this.saving.set(true);
    const id = this.route.snapshot.paramMap.get('id');
    const data = { ...this.form.value, grandTotal: this.grandTotal() };

    const request = id
      ? this.api.updatePurchaseInvoice(+id, data)
      : this.api.createPurchaseInvoice(data);

    request.subscribe({
      next: () => { this.saving.set(false); this.router.navigate(['/transactions/purchase']); },
      error: () => this.saving.set(false)
    });
  }
}
