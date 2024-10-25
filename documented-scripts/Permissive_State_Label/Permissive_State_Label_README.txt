Description: This function figures out and displays the name of the current "permissive" state.  It looks at different settings and conditions to find which permissive is active and shows its label on the screen.

Rev 1.0 -

Key Points:
----------------------------------------
--Permissives: These are likely conditions that need to be met for something to happen (like starting an engine).
--Global Variables: The function uses stored values (in perm...) to determine the active permissive.
--State: The system can be in different states (e.g., "off," "starting," "running"), and each state may have its own permissives.
--Labels: The function displays a user-friendly label (e.g., "RPM > 1000") to indicate the current permissive.
--Shared Virtual Variable: The label is stored in a variable called State_Permissive that can be accessed by other parts of the system.