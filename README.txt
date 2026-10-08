PENG GOODS WHOLESALE — SUPABASE CLOUD VERSION

WHAT CHANGED
- Replaced browser-only data storage with a shared Supabase PostgreSQL database.
- Added live cross-device updates using Supabase Realtime.
- Added Edit buttons to inventory, supply orders, customers, returns/repairs,
  suppliers, expenses, associates, and application user records.
- Kept the existing dashboard, navigation, search, owner/staff UI restrictions,
  dark mode, and supply-order workflow.
- The browser keeps a small local cache for resilience, but Supabase is the
  shared source of truth once connected.
- Login now uses Supabase Auth email + password instead of the old hard-coded
  admin/1234 and staff/0000 browser credentials.

SETUP
1. Create a Supabase project.
2. Open SQL Editor and run: supabase_schema.sql
3. In Authentication > Users, create the owner and staff login accounts.
   Use normal email/password credentials.
4. Copy each Auth user's UUID into the profile INSERT examples at the bottom
   of supabase_schema.sql and run those INSERT statements.
   - owner role = owner
   - staff role = staff
5. Open supabase-config.js and replace:
   YOUR_SUPABASE_PROJECT_URL
   YOUR_SUPABASE_PUBLISHABLE_KEY
   with your project's values.
6. Upload the whole folder to a static web host (or open it through a web
   server). Because the app loads Supabase from a CDN, an internet connection
   is required for cloud login/sync.
7. Open the same hosted app on your laptop and phone. Both devices will use the
   same Supabase database.

IMPORTANT SECURITY
- Use ONLY the Supabase Publishable Key in the browser.
- NEVER use the service_role or secret key in this app.
- Keep Row Level Security enabled.
- The database policies in supabase_schema.sql are the minimum working setup.
  Review them before production use.

MIGRATING EXISTING LOCAL DATA
The original version stored arrays in browser localStorage. This upgraded
version cannot automatically move that old data into Supabase because local
browser data is private to each device. If the old data is important, open
the old app on the device that contains the data and export/copy it before
moving to the cloud version. A future migration script can also be added if
you want to import that data.

EDITING
Each data table now has an Edit button. On mobile, the edit form uses the
same responsive modal layout, so corrections can be made from a phone.

FILES
- index.html
- supabase-config.js
- supabase_schema.sql
- README.txt


FIRST LOGIN
The old demo credentials (admin/1234 and staff/0000) are intentionally not
used by the cloud version. Supabase Auth now controls real authentication.
Create the accounts in Supabase Authentication > Users, then add their UUIDs
to pgw_profiles with the correct owner/staff role.

CLOUD SYNC
When one device saves a change, the other open devices receive the updated
data automatically. If a device is offline, its local cache remains available;
once connected again, the cloud database is the shared source of truth.
