import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import { Member } from '../_models/member';
import { map, of } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MembersService {
  // baseUrl = environment.apiUrl;
  baseUrl = 'https://localhost:5001/api/';
  members: Member[] = [];
  
  constructor(private http: HttpClient) { }

  getMembers(){
    if(this.members.length > 0) return of(this.members);
    // debugger;
    // return this.http.get<Member[]>(this.baseUrl + 'users', this.getHttpOptions());
    return this.http.get<Member[]>(this.baseUrl + 'users').pipe(
      map(members => {
        this.members = members;
        return members;
      })
    );
    // return this.http.get<Member[]>('https://localhost:5001/api/' + 'users', this.getHttpOptions());
  }

  getMember(username: string){
    const member = this.members.find(x => x.userName === username);
    if(member) return of(member);
    // return this.http.get<Member>(this.baseUrl + 'users/' + username, this.getHttpOptions());
    return this.http.get<Member>(this.baseUrl + 'users/' + username);
  }

  // getHttpOptions(){
  //   const userString = localStorage.getItem('user');
  //   if(!userString) return;
  //   const user = JSON.parse(userString);
  //   return {
  //     headers: new HttpHeaders({
  //       Authorization: 'Bearer ' + user.token
  //     })
  //   }
  // }

  updateMember(member: Member){
    return this.http.put(this.baseUrl + 'users', member).pipe(
      map(() => {
        const index = this.members.indexOf(member);
        this.members[index] = {...this.members[index], ...member}
      })
    )
  }
}
