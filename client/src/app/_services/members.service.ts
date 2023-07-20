import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import { Member } from '../_models/member';

@Injectable({
  providedIn: 'root'
})
export class MembersService {
  // baseUrl = environment.apiUrl;
  baseUrl = 'https://localhost:5001/api/';
  
  constructor(private http: HttpClient) { }

  getMembers(){
    // debugger;
    // return this.http.get<Member[]>(this.baseUrl + 'users', this.getHttpOptions());
    return this.http.get<Member[]>(this.baseUrl + 'users');
    // return this.http.get<Member[]>('https://localhost:5001/api/' + 'users', this.getHttpOptions());
  }

  getMember(username: string){
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
}
