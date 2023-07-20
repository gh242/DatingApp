import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Observable, of } from 'rxjs';
import { User } from '../_models/user';
import { AccountService } from '../_services/account.service';


@Component({
  selector: 'app-nav',
  templateUrl: './nav.component.html',
  styleUrls: ['./nav.component.css']
})
export class NavComponent implements OnInit {
  model: any = {};
  // loggedIn = false;
  currentUser$: Observable<User | null> = of(null);
  

  // constructor(private accountService: AccountService ){}
  constructor(public accountService: AccountService, private router: Router, 
    private toastr:ToastrService){}

  ngOnInit():void {    
    // this.getCurrentUser();
    // this.currentUser$ = this.accountService.currentUser$;
  } 

  // getCurrentUser(){
  //   this.accountService.currentUser$.subscribe({
  //     next: user => this.loggedIn = !!user,
  //     error: error => console.log(error)
  //   })
  // }

  login(){
    // console.log(this.model);
    // debugger;
    this.accountService.login(this.model).subscribe({
      // next: response => {
      //   // console.log(response);
      //   // this.loggedIn = true;
      //   this.router.navigateByUrl('/members');
      // },
      next: _ => {
      	this.router.navigateByUrl('/members');
      	this.model = {};
      },
      error: error => console.log(error)      
      // error: error => this.toastr.error(error.error)
    })
  }

  logout(){
    this.accountService.logout();
    // this.loggedIn = false;
    this.router.navigateByUrl('/');
  }
}
