import { Component, inject, signal, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { Subscription } from 'rxjs';
import { AuthService } from '../../core/services/auth.service';
import { User } from '../../core/models';

interface MetricCard {
  title: string;
  value: string;
  icon: string;
  color: string;
  trend?: string;
}

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.scss',
})
export class DashboardComponent implements OnInit, OnDestroy {
  private authService = inject(AuthService);

  currentUser = signal<User | null>(null);
  private userSub?: Subscription;

  metrics = signal<MetricCard[]>([
    { title: 'Total Items', value: '1,248', icon: 'inventory_2', color: '#0f3460', trend: '+12 this week' },
    { title: 'Active Parties', value: '386', icon: 'groups', color: '#e94560', trend: '+5 this month' },
    { title: 'Sales (MTD)', value: 'Rs 2.4M', icon: 'point_of_sale', color: '#16a085', trend: '+18% vs last month' },
    { title: 'Purchases (MTD)', value: 'Rs 1.8M', icon: 'shopping_cart', color: '#8e44ad', trend: '+7% vs last month' },
    { title: 'Stock Value', value: 'Rs 5.2M', icon: 'warehouse', color: '#d35400', trend: '23 low-stock items' },
  ]);

  quickActions = [
    { label: 'New Sales Invoice', route: '/transactions/sales', icon: 'add_shopping_cart' },
    { label: 'New Purchase Invoice', route: '/transactions/purchases', icon: 'add_card' },
    { label: 'Check Stock', route: '/stock', icon: 'inventory' },
    { label: 'Run Payroll', route: '/payroll/run', icon: 'payment' },
  ];

  recentActivities = [
    { text: 'Sales Invoice #1024 created for Maple Textiles', time: '10 min ago', icon: 'receipt_long' },
    { text: 'Purchase Invoice #582 received from Cotton Corp', time: '1 hour ago', icon: 'local_shipping' },
    { text: 'Stock adjustment for Yarn (Synthetic 40s)', time: '3 hours ago', icon: 'edit_note' },
    { text: 'Monthly payroll processed for 142 employees', time: 'Yesterday', icon: 'payments' },
    { text: 'Work Order #89 completed on Machine #12', time: 'Yesterday', icon: 'task_alt' },
  ];

  ngOnInit(): void {
    this.userSub = this.authService.currentUser$.subscribe(user => {
      this.currentUser.set(user);
    });
  }

  ngOnDestroy(): void {
    this.userSub?.unsubscribe();
  }
}
