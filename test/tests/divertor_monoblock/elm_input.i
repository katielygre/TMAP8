elm_start_time = 100.0 #s
elm_ramp_time = 0.001 #s

elm_peak_time = ${fparse elm_start_time + elm_ramp_time}
elm_end_time = ${fparse elm_start_time + 2*elm_ramp_time}

elm_heat_flux_amplitude = 10.0e7 #W/m^2

!include divertor_monoblock.i

[BCs]
    [temp_top]
        # type = FunctionNeumannBC
        # variable = temperature
        # boundary = 'top'
        function := total_heat_flux_function
    []
[]

[Functions]
    [elm_time_function]
        type = ParsedFunction
        symbol_values = 't_in_cycle'
        symbol_names = 't_in_cycle'
        expression =   'if(t_in_cycle < ${elm_start_time}, 0,
                        if(t_in_cycle < ${elm_peak_time}, (t_in_cycle - ${elm_start_time}) / ${elm_ramp_time},
                        if(t_in_cycle < ${elm_end_time}, (1 - (t_in_cycle - ${elm_peak_time}) / ${elm_ramp_time}), 0.0)))'
    []
    [elm_heat_flux_function]
        type = ParsedFunction
        symbol_values = 'elm_time_function'
        symbol_names = 'elm_time_function'
        expression = 'elm_time_function * ${elm_heat_flux_amplitude}'
    []
    [total_heat_flux_function]
        type = ParsedFunction
        symbol_values = 'elm_heat_flux_function temp_flux_bc_function'
        symbol_names = 'elm_heat_flux plasma_heat_flux'
        expression = 'elm_heat_flux + plasma_heat_flux'
    []
[]
