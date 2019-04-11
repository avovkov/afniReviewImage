# define the group
        Group = TT_N27

# define various States
        StateDef = smoothwm
        StateDef = pial
        StateDef = inflated
        StateDef = occip.patch.3d
        StateDef = occip.patch.flat
        StateDef = occip.flat.patch.3d
        StateDef = fusiform.patch.flat
        StateDef = full.patch.3d
        StateDef = full.patch.flat
        StateDef = full.flat.patch.3d
        StateDef = full.flat
        StateDef = flat.patch
        StateDef = sphere
        StateDef = white
        StateDef = sphere.reg
        StateDef = rh.sphere.reg
        StateDef = lh.sphere.reg
        StateDef = pial-outer-smoothed
        StateDef = inf_200

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = lh.smoothwm.gii
        LocalDomainParent = SAME
        SurfaceState = smoothwm
        EmbedDimension = 3
        Anatomical = Y
        LabelDset = lh.aparc.a2009s.annot.niml.dset

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.smoothwm.gii
        LocalDomainParent = SAME
        SurfaceState = smoothwm
        EmbedDimension = 3
        Anatomical = Y
        LabelDset = rh.aparc.a2009s.annot.niml.dset



NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = lh.pial.gii
        LocalDomainParent = lh.smoothwm.gii
        SurfaceState = pial
        EmbedDimension = 3
        Anatomical = Y

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.pial.gii
        LocalDomainParent = rh.smoothwm.gii
        SurfaceState = pial
        EmbedDimension = 3
        Anatomical = Y


NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = lh.inflated.gii
        LocalDomainParent = lh.smoothwm.gii
        SurfaceState = inflated
        EmbedDimension = 3
        Anatomical = N

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.inflated.gii
        LocalDomainParent = rh.smoothwm.gii
        SurfaceState = inflated
        EmbedDimension = 3
        Anatomical = N




NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = lh.white.gii
        LocalDomainParent = lh.smoothwm.gii
        SurfaceState = white
        EmbedDimension = 3
        Anatomical = Y

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.white.gii
        LocalDomainParent = rh.smoothwm.gii
        SurfaceState = white
        EmbedDimension = 3
        Anatomical = Y


NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = lh.inf_200.gii
        LocalDomainParent = lh.smoothwm.gii
        SurfaceState = inf_200
        EmbedDimension = 3
        Anatomical = N

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.inf_200.gii
        LocalDomainParent = rh.smoothwm.gii
        SurfaceState = inf_200
        EmbedDimension = 3
        Anatomical = N


