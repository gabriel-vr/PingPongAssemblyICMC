
loadn r0, #0

addn r0,r0, #65

loadn r1, #0


outchar r0, r1

loop:
    loadn r0, #0
    loadn r1, #0
    cmp r0, r1
    jeq loop