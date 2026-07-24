import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators, FormArray } from '@angular/forms';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { Party, StateMaster } from '../../../core/models';

@Component({
  selector: 'app-party-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  template: `
    <div class="form-page">
      <h2>{{ isEdit() ? 'Edit Party' : 'New Party' }}</h2>

      @if (loading()) {
        <div class="loading">Loading...</div>
      } @else {
        <form [formGroup]="form" (ngSubmit)="onSubmit()">
          <div class="form-section">
            <h3>Basic Info</h3>
            <div class="form-grid">
              <div class="form-group">
                <label>Party Code *</label>
                <input formControlName="code" class="form-control" />
              </div>
              <div class="form-group">
                <label>Party Name *</label>
                <input formControlName="name" class="form-control" />
              </div>
              <div class="form-group">
                <label>Legal Name</label>
                <input formControlName="legalName" class="form-control" />
              </div>
              <div class="form-group">
                <label>Party Type *</label>
                <select formControlName="partyType" class="form-control">
                  <option value="">Select</option>
                  <option value="Customer">Customer</option>
                  <option value="Supplier">Supplier</option>
                  <option value="Both">Both</option>
                </select>
              </div>
              <div class="form-group">
                <label>Contact Person</label>
                <input formControlName="contactPerson" class="form-control" />
              </div>
              <div class="form-group">
                <label>Email</label>
                <input type="email" formControlName="email" class="form-control" />
              </div>
              <div class="form-group">
                <label>Phone</label>
                <input formControlName="phone" class="form-control" />
              </div>
              <div class="form-group">
                <label>Mobile</label>
                <input formControlName="mobile" class="form-control" />
              </div>
              <div class="form-group">
                <label>Website</label>
                <input formControlName="website" class="form-control" />
              </div>
            </div>
          </div>

          <div class="form-section">
            <h3>Address</h3>
            <div formGroupName="address">
              <div class="form-grid">
                <div class="form-group">
                  <label>Address Line 1</label>
                  <input formControlName="addressLine1" class="form-control" />
                </div>
                <div class="form-group">
                  <label>Address Line 2</label>
                  <input formControlName="addressLine2" class="form-control" />
                </div>
                <div class="form-group">
                  <label>City</label>
                  <input formControlName="city" class="form-control" />
                </div>
                <div class="form-group">
                  <label>State</label>
                  <select formControlName="stateId" class="form-control">
                    <option value="">Select</option>
                    @for (s of states(); track s.id) {
                      <option [value]="s.id">{{ s.name }}</option>
                    }
                  </select>
                </div>
                <div class="form-group">
                  <label>Pincode</label>
                  <input formControlName="pincode" class="form-control" />
                </div>
              </div>
            </div>
          </div>

          <div class="form-section">
            <h3>GST / Tax</h3>
            <div class="form-grid">
              <div class="form-group">
                <label>GSTIN</label>
                <input formControlName="gstin" class="form-control" maxlength="15" />
              </div>
              <div class="form-group">
                <label>PAN</label>
                <input formControlName="pan" class="form-control" maxlength="10" />
              </div>
              <div class="form-group">
                <label>
                  <input type="checkbox" formControlName="isTDSApplicable" /> TDS Applicable
                </label>
              </div>
              <div class="form-group">
                <label>TDS Rate (%)</label>
                <input type="number" step="0.01" formControlName="tdsRate" class="form-control" />
              </div>
              <div class="form-group">
                <label>
                  <input type="checkbox" formControlName="isTCSApplicable" /> TCS Applicable
                </label>
              </div>
              <div class="form-group">
                <label>TCS Rate (%)</label>
                <input type="number" step="0.01" formControlName="tcsRate" class="form-control" />
              </div>
            </div>
          </div>

          <div class="form-section">
            <h3>Banking &amp; Credit</h3>
            <div class="form-grid">
              <div class="form-group">
                <label>Credit Limit</label>
                <input type="number" step="0.01" formControlName="creditLimit" class="form-control" />
              </div>
              <div class="form-group">
                <label>Credit Days</label>
                <input type="number" formControlName="creditDays" class="form-control" />
              </div>
            </div>
          </div>

          <div class="form-actions">
            <button type="submit" class="btn btn-primary" [disabled]="form.invalid || saving()">
              {{ saving() ? 'Saving...' : 'Save' }}
            </button>
            <button type="button" class="btn btn-secondary" routerLink="/master/parties">Cancel</button>
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
    .form-group label { font-size: 13px; margin-bottom: 4px; color: #555; display: flex; align-items: center; gap: 6px; }
    .form-control { padding: 6px 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
    .form-actions { display: flex; gap: 8px; }
    .btn { padding: 8px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
    .btn-primary { background: #1976d2; color: #fff; }
    .btn-secondary { background: #e0e0e0; color: #333; }
    .btn:disabled { opacity: 0.6; cursor: not-allowed; }
    .loading { padding: 40px; text-align: center; color: #666; }
  `]
})
export class PartyFormComponent implements OnInit {
  private fb = inject(FormBuilder);
  private api = inject(ApiService);
  private route = inject(ActivatedRoute);
  private router = inject(Router);

  form: FormGroup = this.fb.group({
    code: ['', Validators.required],
    name: ['', Validators.required],
    legalName: [''],
    partyType: ['', Validators.required],
    contactPerson: [''],
    email: [''],
    phone: [''],
    mobile: [''],
    website: [''],
    address: this.fb.group({
      addressLine1: [''],
      addressLine2: [''],
      city: [''],
      stateId: [''],
      pincode: ['']
    }),
    gstin: [''],
    pan: [''],
    isTDSApplicable: [false],
    tdsRate: [null],
    isTCSApplicable: [false],
    tcsRate: [null],
    creditLimit: [null],
    creditDays: [null],
    isActive: [true]
  });

  isEdit = signal(false);
  loading = signal(false);
  saving = signal(false);
  states = signal<StateMaster[]>([]);

  ngOnInit(): void {
    this.api.getAllStates().subscribe(s => this.states.set(s));
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEdit.set(true);
      this.loadParty(+id);
    }
  }

  loadParty(id: number): void {
    this.loading.set(true);
    this.api.getPartyById(id).subscribe({
      next: (party) => {
        this.form.patchValue({
          code: party.code,
          name: party.name,
          legalName: party.legalName,
          partyType: party.partyType,
          contactPerson: party.contactPerson,
          email: party.email,
          phone: party.phone,
          mobile: party.mobile,
          website: party.website,
          gstin: party.gstin,
          pan: party.pan,
          isTDSApplicable: party.isTDSApplicable,
          tdsRate: party.tdsRate,
          isTCSApplicable: party.isTCSApplicable,
          tcsRate: party.tcsRate,
          creditLimit: party.creditLimit,
          creditDays: party.creditDays,
          address: {
            addressLine1: party.addresses?.[0]?.addressLine1 ?? '',
            addressLine2: party.addresses?.[0]?.addressLine2 ?? '',
            city: party.addresses?.[0]?.city ?? '',
            stateId: party.addresses?.[0]?.stateId ?? '',
            pincode: party.addresses?.[0]?.pincode ?? ''
          }
        });
        this.loading.set(false);
      },
      error: () => this.loading.set(false)
    });
  }

  onSubmit(): void {
    if (this.form.invalid) return;
    this.saving.set(true);
    const id = this.route.snapshot.paramMap.get('id');
    const data = this.form.value;

    const request = id
      ? this.api.updateParty(+id, data)
      : this.api.createParty(data);

    request.subscribe({
      next: () => {
        this.saving.set(false);
        this.router.navigate(['/master/parties']);
      },
      error: () => this.saving.set(false)
    });
  }
}
