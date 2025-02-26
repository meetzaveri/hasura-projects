-- -*- sql-product: postgres; -*-

alter table assignment enable row level security;

alter table organization enable row level security;

-- alter table permission enable row level security;

alter table project enable row level security;

alter table timesheet enable row level security;

-- alter table "user" enable row level security;

-- alter table "user_permission" enable row level security;

create policy query on assignment for select using (true);

create policy query on organization for select using (true);

-- create policy query on permission for select using (true);

create policy query on project for select using (true);

create policy query on timesheet for select using (true);

-- create policy query on "user" for select using (true);

-- create policy query on user_permission for select using (true);

create policy delete_assigned_projects on project for delete using (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'delete_assigned_projects'
  )
  and
  exists (
    select
      1
      from
	assignment
     where true
       and project_id = project.id
       and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
  )
);

create policy edit_all_projects on project for update using (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'edit_all_projects'
  )
);

create policy edit_all_timesheets on timesheet for update using (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'edit_all_timesheets'
  )
);

create policy edit_assigned_projects on project for update using (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'edit_assigned_projects'
  )
  and
  exists (
    select
      1
      from
	assignment
     where true
       and project_id = project.id
       and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
  )
);

create policy view_all_projects on project for select using (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'view_all_projects'
  )
);

create policy view_all_timesheets on timesheet for select using (
  exists (
    select
      1
      from
	user_permission
	join permission on user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'view_all_timesheets'
  )
);
