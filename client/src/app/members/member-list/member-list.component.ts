import { Component, OnInit } from '@angular/core';
import { Observable, take } from 'rxjs';
import { Member } from 'src/app/_models/member';
import { PaginatedResult, Pagination } from 'src/app/_models/pagination';
import { User } from 'src/app/_models/user';
import { UserParams } from 'src/app/_models/userParams';
import { AccountService } from 'src/app/_services/account.service';
import { MembersService } from 'src/app/_services/members.service';

@Component({
  selector: 'app-member-list',
  templateUrl: './member-list.component.html',
  styleUrls: ['./member-list.component.css']
})
export class MemberListComponent implements OnInit {
  // members: Member[] = [];
  // members$: Observable<Member[]> | undefined;
  members: Member[] = [];
  pagination: Pagination | undefined;
  // pageNumber = 1;
  // pageSize = 5;
  userParams: UserParams | undefined;
  // user: User | undefined;
  genderList = [{value: 'male', display: 'Males'}, {value: 'female', display: 'Females'}]

  // constructor(private memberService: MembersService, private accountService: AccountService){
  constructor(private memberService: MembersService){
    this.userParams = this.memberService.getUserParams();
    // this.accountService.currentUser$.pipe(take(1)).subscribe({
    //   next: user => {
    //     if(user) {
    //       this.userParams = new UserParams(user);
    //       this.user = user;
    //     }
    //   }
    // })
  }

  ngOnInit(): void {
    // debugger;
    // this.loadMembers();
    // this.members$ = this.memberService.getMembers();
    this.loadMembers();
  }

  loadMembers(){
    // this.memberService.getMembers().subscribe({
    //   next: members => this.members = members
    // })
    // if(!this.userParams) return;
    if(this.userParams) {
      this.memberService.setUserParams(this.userParams);
      // debugger;
      this.memberService.getMembers(this.userParams).subscribe({
        next: response => {
          if(response.result && response.pagination){
            this.members = response.result;
            this.pagination = response.pagination;
          }
        }
      })
    }
  }

  resetFilters(){
    // if(this.user){
      // this.userParams = new UserParams(this.user);
      this.userParams = this.memberService.resetUserParams();
      this.loadMembers();
    // }
  }

  pageChanged(event: any){
    if(this.userParams && this.userParams?.pageNumber !== event.page){
      this.userParams.pageNumber = event.page;
      this.memberService.setUserParams(this.userParams);
      this.loadMembers();
    }
  }
}
