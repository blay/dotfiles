:R*?:nnote::
FormatTime, CurrentDateTime,, yyyyMMddHHmm
SendInput %CurrentDateTime%
return

:R*?:ddate::
FormatTime, CurrentDateTime,, yyyy-MM-dd
SendInput %CurrentDateTime%
return

:R*?:ttime::
FormatTime, CurrentDateTime,, HH:mm
SendInput %CurrentDateTime%
return

:R*?:cpl::
FormatTime, CurrentDateTime,, yyyy-MM-dd
SendInput completed:%CurrentDateTime%
return

:R*?:crt::
FormatTime, CurrentDateTime,, yyyy-MM-dd
SendInput created:%CurrentDateTime%
return

:R*?:ttt::
FormatTime, CurrentDateTime,, yyyy-MM-dd
SendInput {#}TODO: created:%CurrentDateTime%
return

:R*?:ttx::
FormatTime, CurrentDateTime,, yyyy-MM-dd
SendInput {#}NEXT: created:%CurrentDateTime%
return

:R*?:ttn::
FormatTime, CurrentDateTime,, yyyy-MM-dd
SendInput {#}NOW: created:%CurrentDateTime%
return

:R*?:ttr::
FormatTime, CurrentDateTime,, yyyy-MM-dd
SendInput {#}FIX: created:%CurrentDateTime%
return

:R*?:ttd::
FormatTime, CurrentDateTime,, yyyy-MM-dd
SendInput {#}DONE: completed:%CurrentDateTime%
return
