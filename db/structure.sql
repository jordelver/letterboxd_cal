create table movies (
  id serial primary key not null,
  original_title text unique not null,
  title text not null,
  year text not null,
  release_date date,
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

