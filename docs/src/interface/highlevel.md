# Core functions

This page presents the core functions to manipulate networks. Whenever possible,
the approach of `EcologicalNetwork` is to overload functions from `Base`.

## Accessing species

```@docs
species
```

## Accessing interactions

### Presence of an interaction

```@docs
has_interaction
```

### Network slices

```@docs
getindex
```

## Network utilities

### Network size

```@docs
size
```

### Species richness

```@docs
richness
```

### Changing network shape

```@docs
transpose
nodiagonal
```
