import { Injectable, inject } from '@angular/core';
import { CanDeactivate, CanDeactivateFn } from '@angular/router';
import { MemberEditComponent } from '../members/member-edit/member-edit.component';
import { ConfirmService } from '../_services/confirm.service';

// @Injectable({
//   providedIn: 'root'
// })
// export class PreventUnsavedChangesGuard implements CanDeactivate<MemberEditComponent> {
//   canDeactivate( component: MemberEditComponent): boolean {
//     if(component.editForm?.dirty){
//       return confirm('Are you sure you want to continue? Any unsaved changes will be lost')
//     }
//     return true;
//   }
  
// }
export const PreventUnsavedChangesGuard: CanDeactivateFn<MemberEditComponent> = (component) => {
  const confirmService = inject(ConfirmService);

  if(component.editForm?.dirty) {
    return confirmService.confirm();
  }
  
  return true;
}
