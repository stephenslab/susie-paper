dropped = 1
own = in_12 = in_34 = 0
mixed = list()
mixed_idx = 1
for (s in cs$cs) {
    # set of x_1 and x_2
    if ((1 %in% s || 2 %in% s) && !(3 %in% s || 4 %in% s)) {
        if (5 %in% s) {
            in_12 = in_12 + 1
            dropped = 0
        }
    # set of x_3 and x_4
    } else if (!(1 %in% s || 2 %in% s) && (3 %in% s || 4 %in% s)) {
        if (5 %in% s) {
            in_34 = in_34 + 1
            dropped = 0
        }
    # set of x_5
    } else if (5 %in% s || !(1 %in% s || 2 %in% s || 3 %in% s || 4 %in% s)) {
        own = own + 1
    # set where variables 1-4 got mixed up
    } else if ((1 %in% s || 2 %in% s) || (3 %in% s || 4 %in% s)) {
        mixed[[mixed_idx]] = s
        mixed_idx = mixed_idx + 1
    }
}