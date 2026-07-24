import { Routes } from '@angular/router';
import { authGuard } from './core/guards/auth.guard';

export const routes: Routes = [
  {
    path: 'login',
    loadComponent: () =>
      import('./features/auth/login.component').then(m => m.LoginComponent),
  },
  {
    path: '',
    loadComponent: () =>
      import('./shared/layout/layout.component').then(m => m.LayoutComponent),
    canActivate: [authGuard],
    children: [
      {
        path: 'dashboard',
        loadComponent: () =>
          import('./features/dashboard/dashboard.component').then(m => m.DashboardComponent),
      },
      // Master Data
      {
        path: 'master/items',
        loadComponent: () =>
          import('./features/master/items/item-list.component').then(m => m.ItemListComponent),
      },
      {
        path: 'master/items/new',
        loadComponent: () =>
          import('./features/master/items/item-form.component').then(m => m.ItemFormComponent),
      },
      {
        path: 'master/items/:id/edit',
        loadComponent: () =>
          import('./features/master/items/item-form.component').then(m => m.ItemFormComponent),
      },
      {
        path: 'master/parties',
        loadComponent: () =>
          import('./features/master/parties/party-list.component').then(m => m.PartyListComponent),
      },
      {
        path: 'master/parties/new',
        loadComponent: () =>
          import('./features/master/parties/party-form.component').then(m => m.PartyFormComponent),
      },
      {
        path: 'master/parties/:id/edit',
        loadComponent: () =>
          import('./features/master/parties/party-form.component').then(m => m.PartyFormComponent),
      },
      // Transactions
      {
        path: 'transactions/sales',
        loadComponent: () =>
          import('./features/transactions/sales/sales-invoice-list.component').then(m => m.SalesInvoiceListComponent),
      },
      {
        path: 'transactions/sales/new',
        loadComponent: () =>
          import('./features/transactions/sales/sales-invoice-form.component').then(m => m.SalesInvoiceFormComponent),
      },
      {
        path: 'transactions/sales/:id/edit',
        loadComponent: () =>
          import('./features/transactions/sales/sales-invoice-form.component').then(m => m.SalesInvoiceFormComponent),
      },
      {
        path: 'transactions/purchases',
        loadComponent: () =>
          import('./features/transactions/purchase/purchase-invoice-list.component').then(m => m.PurchaseInvoiceListComponent),
      },
      {
        path: 'transactions/purchases/new',
        loadComponent: () =>
          import('./features/transactions/purchase/purchase-invoice-form.component').then(m => m.PurchaseInvoiceFormComponent),
      },
      {
        path: 'transactions/purchases/:id/edit',
        loadComponent: () =>
          import('./features/transactions/purchase/purchase-invoice-form.component').then(m => m.PurchaseInvoiceFormComponent),
      },
      // Stock
      {
        path: 'stock',
        loadComponent: () =>
          import('./features/stock/stock-list.component').then(m => m.StockListComponent),
      },
      // Payroll
      {
        path: 'payroll/employees',
        loadComponent: () =>
          import('./features/payroll/employee-list.component').then(m => m.EmployeeListComponent),
      },
      {
        path: 'payroll/employees/new',
        loadComponent: () =>
          import('./features/payroll/employee-form.component').then(m => m.EmployeeFormComponent),
      },
      {
        path: 'payroll/employees/:id/edit',
        loadComponent: () =>
          import('./features/payroll/employee-form.component').then(m => m.EmployeeFormComponent),
      },
      {
        path: 'payroll/attendance',
        loadComponent: () =>
          import('./features/payroll/attendance.component').then(m => m.AttendanceComponent),
      },
      {
        path: 'payroll/run',
        loadComponent: () =>
          import('./features/payroll/payroll.component').then(m => m.PayrollComponent),
      },
      // Maintenance
      {
        path: 'maintenance/machines',
        loadComponent: () =>
          import('./features/maintenance/machine-list.component').then(m => m.MachineListComponent),
      },
      {
        path: 'maintenance/machines/new',
        loadComponent: () =>
          import('./features/maintenance/machine-form.component').then(m => m.MachineFormComponent),
      },
      {
        path: 'maintenance/machines/:id/edit',
        loadComponent: () =>
          import('./features/maintenance/machine-form.component').then(m => m.MachineFormComponent),
      },
      {
        path: 'maintenance/spare-parts',
        loadComponent: () =>
          import('./features/maintenance/spare-part-list.component').then(m => m.SparePartListComponent),
      },
      {
        path: 'maintenance/work-orders',
        loadComponent: () =>
          import('./features/maintenance/work-order-list.component').then(m => m.WorkOrderListComponent),
      },
      {
        path: '',
        redirectTo: 'dashboard',
        pathMatch: 'full',
      },
    ],
  },
  {
    path: '**',
    redirectTo: 'login',
  },
];
