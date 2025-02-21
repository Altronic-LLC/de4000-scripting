Description: Loading Button / Loading Status - This button displays three loading statuses: Not Ready, Ready, and Loaded.

Code Reference:
-----------------------------------------


Functionality:

Loading States: It defines three main loading states:
"Unloaded": The initial state, indicating the process is not loaded.
"Loaded": The process has been loaded and is ready or active.
"Not Ready": Conditions are not met for loading to occur.
State Machine Interaction: The code interacts with a state machine (get_state()) that likely controls the overall process flow. Loading is typically allowed in State 7 (and possibly State 8).
Permissive Check: In State 7, it checks a permissive condition (get_gbl("perm7aEnabled",0)) and another condition (get_sVirt("permissive_met","none")) to determine if loading is allowed (Load_State = 1).
Manual Loading Control: A toggle button ("Load Control") allows the operator to manually initiate or cancel loading in State 7 when permissives are met.
Automatic Loading: In State 8, the process is automatically considered "Loaded."
Status Feedback: The "Load Status" variable provides visual feedback to the operator, with color-coded messages:
"Ready To Load" (Yellow): Ready to load in State 7.
"Loaded" (Green): Loaded and potentially active in States 7 or 8.
"Not Ready" (Red): Loading is not allowed in other states.
Load Complete Signal: A Load_Complete variable is set to 1 when loading is complete, which could trigger other actions in the system.

-----------------------------------------
Code Logic:

Initialization: Sets initial values for "Load Control" and "Load Status" variables.
State-Based Control: Uses if and elseif conditions to manage loading behavior based on the current state of the state machine.
Toggle Button Handling: Uses checkToggle (a custom function, not defined here) to manage the "Load Control" button's functionality.
Status Updates: Sets the "Load Status" and Load_Complete variables based on the loading state and state machine.