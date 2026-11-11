-- SokolApp Sample Application using libffi-euphoria
include std/ffi.e
include std/machine.e
include sokol_app.e

-- 1. Define callbacks as local/private functions to avoid redefinition conflicts
function init_cb(atom udata)
    sapp_set_window_title("Hello from OpenEuphoria & Sokol!")
    puts(1, "Sokol initialized successfully!\n")
    return 0
end function

function frame_cb(atom udata)
    atom fc = sapp_frame_count()
    if remainder(fc, 300) = 0 then
        sapp_set_window_title(sprintf("Sokol Frame: %d", fc))
    end if
    return 0
end function

function cleanup_cb(atom udata)
    puts(1, "Cleaning up Sokol application...\n")
    return 0
end function

function event_cb(atom event_ptr, atom udata)
    return 0
end function

procedure main()
    if app = 0 then
        puts(1, "Error: Sokol library not loaded.\n")
        abort(1)
    end if

    -- 2. Create callback function pointers via call_back()
    atom c_init    = call_back(routine_id("init_cb"))
    atom c_frame   = call_back(routine_id("frame_cb"))
    atom c_cleanup = call_back(routine_id("cleanup_cb"))
    atom c_event   = call_back(routine_id("event_cb"))

    -- 3. Allocate a blank sapp_desc struct (safely zeroed out)
    atom desc = allocate_struct(sapp_desc)

    puts(1, "Starting Sokol application loop...\n")
    
    -- 4. Run the application
    sapp_run(desc)
    
    -- Free allocated struct memory when done
    free(desc)
end procedure

main()
­3.21