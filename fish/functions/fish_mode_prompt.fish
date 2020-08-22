function fish_mode_prompt
  switch $fish_bind_mode
    case default
      set_color --bold red
      set letter 'N'
    case insert
      set_color --bold green
      set letter 'I'
    case replace_one
      set_color --bold green
      set letter 'R'
    case visual
      set_color --bold brmagenta
      set letter 'V'
    case '*'
      set_color --bold red
      set letter '?'
  end
  echo "[$letter] "
  set_color normal
end
