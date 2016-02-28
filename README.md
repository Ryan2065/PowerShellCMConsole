# PowerShellCMConsole
A PowerShell console for Configuration Manager.

The goal of this project is to add common administrative tasks to this console so actions can be 
performed on servers without having to install the full admin console or remote into a computer
with the console. Obviously there will be some additional featured added to make this console
worthwile in other scenarios.

Working:
  - Gets boundaries
  - Can set connection settings 


To Do:
  - Boundaries
      - Edit boundary
      - Boundary analyzer (find all devices not in boundary)
         - Create UI
         - Filter by Collection / Boundary
  - Boundary Group
      - Create UI
      - Create Queries
      - Allow editing of boundary groups
      - Boundary analyzer
          - Create UI
          - Filter by collection / group
  - Discovery Methods
      - Create UI
      - All actions you can do in the console
      - Bulk add discovery methods with the same settings (so add 10 AD OUs if all the settings are the same)
  - Lots of other stuff...