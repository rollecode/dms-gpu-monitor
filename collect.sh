#!/bin/sh
# Emits TYPE<TAB>PERCENT<TAB>PID<TAB>NAME<TAB>DETAIL per line, unsorted.
# P = process (killable), F = idle (pinned, accent), T = scale.
# pmon's own command column is truncated and picks up argv ("1Password --gpu"),
# so names come from comm. Unlike memory, sm% per process does not partition:
# idle is derived from the GPU-wide utilisation, not from 100 minus the sum.

detail_for() {
  _pid=$1
  _comm=$2
  _cmd=$(tr '\0' '\n' < "/proc/$_pid/cmdline" 2>/dev/null)
  [ -z "$_cmd" ] && return

  _t=$(printf '%s\n' "$_cmd" | sed -n 's/^--type=//p' | head -1)
  if [ -n "$_t" ]; then
    printf '%s' "$_t"
    return
  fi

  case "$_comm" in
    python*|node|bun|ruby|perl|java)
      _s=$(printf '%s\n' "$_cmd" | sed -n '2,$p' | grep -v '^-' | head -1)
      [ -n "$_s" ] && printf '%s' "$(basename "$_s")"
      ;;
    claude|bash|sh|zsh|fish|nvim|vim|git)
      _c=$(readlink "/proc/$_pid/cwd" 2>/dev/null)
      [ -n "$_c" ] && printf '%s' "$(basename "$_c")"
      ;;
    WebKitWebProcess|*WebProcess)
      _ppid=$(awk '{print $4}' "/proc/$_pid/stat" 2>/dev/null)
      _p=$(cat "/proc/$_ppid/comm" 2>/dev/null)
      [ -n "$_p" ] && printf 'via %s' "$_p"
      ;;
  esac
}

timeout 5 nvidia-smi pmon -c 1 -s u 2>/dev/null | awk '
!/^#/ && $2 ~ /^[0-9]+$/ {
  sm = $4
  if (sm == "-" || sm == "") sm = 0
  if (sm+0 <= 0) next
  pid = $2
  c=""; f="/proc/" pid "/comm"; getline c < f; close(f)
  if (c=="") c="pid " pid
  printf "%d\t%s\t%s\n", sm, pid, c
}' | while IFS="$(printf '\t')" read -r sm pid name; do
  printf 'P\t%s\t%s\t%s\t%s\n' "$sm" "$pid" "$name" "$(detail_for "$pid" "$name")"
done

nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,fan.speed --format=csv,noheader,nounits 2>/dev/null | awk -F', ' '
{
  printf "F\t%d\t-\tIdle\t\t%%\n", 100-$1
  if ($2 != "" && $2 != "[N/A]") printf "I\t%d\t-\tTemp\t\t°C\n", $2
  if ($3 != "" && $3 != "[N/A]") printf "I\t%d\t-\tFan\t\t%%\n", $3
  printf "T\t100\t-\tscale\t\t\n"
}'
