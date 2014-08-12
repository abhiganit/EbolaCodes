function EbolaModelFit

    optout = fminsearch( @ErrorFunction, 0.1)

end