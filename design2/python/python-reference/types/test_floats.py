if 12.0 + 24.0 != 36.0: raise Exception('float op +')
if 12.0 + (-24.0) != -12.0: raise Exception('float op +/-')
if (-12.0) + 24.0 != 12.0: raise Exception('float op -/+')
if (-12.0) + (-24.0) != -36.0: raise Exception('float op -/+/-')
if not 12.0 < 24.0: raise Exception('float op <')
if not -24.0 < -12.0: raise Exception('float op < negative')
