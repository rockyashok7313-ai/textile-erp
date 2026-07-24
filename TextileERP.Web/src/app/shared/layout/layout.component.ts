import { Component, inject, signal, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';
import { Subscription } from 'rxjs';
import { AuthService } from '../../core/services/auth.service';
import { User } from '../../core/models';

interface NavItem {
  label: string;
  route?: string;
  icon: string;
  children?: NavItem[];
  expanded?: boolean;
}

@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterLink, RouterLinkActive],
  templateUrl: './layout.component.html',
  styleUrl: './layout.component.scss',
})
export class LayoutComponent implements OnInit, OnDestroy {
  authService = inject(AuthService);
  sidebarCollapsed = signal(false);
  currentUser = signal<User | null>(null);

  private userSub?: Subscription;

  menuGroups = signal<NavItem[]>([
    {
      label: 'Dashboard',
      route: '/dashboard',
      icon: 'speed',
    },
    {
      label: 'Master Data',
      icon: 'database',
      children: [
        { label: 'Items', route: '/master/items', icon: 'inventory_2' },
        { label: 'Parties', route: '/master/parties', icon: 'groups' },
      ],
    },
    {
      label: 'Transactions',
      icon: 'receipt_long',
      children: [
        { label: 'Sales Invoice', route: '/transactions/sales', icon: 'point_of_sale' },
        { label: 'Purchase Invoice', route: '/transactions/purchases', icon: 'shopping_cart' },
      ],
    },
    {
      label: 'Inventory',
      icon: 'warehouse',
      children: [
        { label: 'Stock', route: '/stock', icon: 'inventory' },
      ],
    },
    {
      label: 'Payroll',
      icon: 'payments',
      children: [
        { label: 'Employees', route: '/payroll/employees', icon: 'people' },
        { label: 'Attendance', route: '/payroll/attendance', icon: 'event_available' },
        { label: 'Payroll', route: '/payroll/run', icon: 'account_balance_wallet' },
        { label: 'Leave', route: '/payroll/leave', icon: 'beach_access' },
      ],
    },
    {
      label: 'Maintenance',
      icon: 'build',
      children: [
        { label: 'Machines', route: '/maintenance/machines', icon: 'precision_manufacturing' },
        { label: 'Spare Parts', route: '/maintenance/spare-parts', icon: 'settings_suggest' },
        { label: 'Work Orders', route: '/maintenance/work-orders', icon: 'assignment' },
      ],
    },
  ]);

  ngOnInit(): void {
    this.userSub = this.authService.currentUser$.subscribe(user => {
      this.currentUser.set(user);
    });
  }

  ngOnDestroy(): void {
    this.userSub?.unsubscribe();
  }

  toggleSidebar(): void {
    this.sidebarCollapsed.update(v => !v);
  }

  toggleGroup(group: NavItem): void {
    this.menuGroups.update(groups =>
      groups.map(g =>
        g.label === group.label ? { ...g, expanded: !g.expanded } : g
      )
    );
  }
}
