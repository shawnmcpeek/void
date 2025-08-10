# The Void: Graveyard Edition - Mobile Game Design Document

## Game Overview
A haunting mobile infinite scroller where players navigate a dark graveyard path using only a flashlight for illumination. Dark creatures lurk in the shadows, and prolonged exposure to light makes them aggressive. The core tension comes from managing light exposure while navigating an endless, atmospheric path. **Designed specifically for mobile devices with touch-optimized controls.**

## Core Gameplay Mechanics

### Player Movement & Control (Mobile-Optimized)
- **Path Navigation**: Player moves forward automatically along a winding graveyard path
- **Lateral Movement**: Touch and drag on left side of screen to move left/right within path boundaries
- **Flashlight Control**: Touch and drag on right side of screen to control flashlight beam angle
- **Movement Constraints**: Limited lateral movement range to keep player on path
- **One-Handed Play**: Designed to be playable with one hand (thumb controls)

### Flashlight System
- **Beam Mechanics**: 
  - Cone-shaped light beam with adjustable angle
  - Limited range (optimized for mobile screen size)
  - Soft, atmospheric lighting with simplified falloff
- **Light Properties**:
  - Warm, yellow-white color (Color(1.0, 0.95, 0.8))
  - Energy level affects brightness
  - Range item cull mask for enemy detection

### Enemy System - Shadow Creatures

#### Enemy Types
1. **White Eyes** (Common - 50% spawn rate)
   - Moderate threat level
   - Light tolerance: 2 seconds
   - Move speed: 60 units/sec (mobile-optimized)
   - Attack speed: 120 units/sec

2. **Red Eyes** (Uncommon - 30% spawn rate)
   - High threat level
   - Light tolerance: 1.5 seconds
   - Move speed: 80 units/sec
   - Attack speed: 140 units/sec

3. **Reflective Eyes** (Rare - 20% spawn rate)
   - Very high threat level
   - Light tolerance: 1 second
   - Move speed: 100 units/sec
   - Attack speed: 160 units/sec

#### Enemy States
- **HIDDEN**: Invisible, no threat
- **VISIBLE**: Illuminated by flashlight, building aggression
- **AGGRESSIVE**: Light tolerance exceeded, actively pursuing player
- **ATTACKING**: In attack range, dealing damage
- **DEAD**: Defeated, no longer a threat

#### Enemy Behavior
- **Light Exposure Timer**: Counts time spent in flashlight beam
- **Aggression Building**: Becomes more dangerous the longer it's illuminated
- **Movement Patterns**: 
  - Hidden: Stationary or slow patrol
  - Visible: Slow movement toward light source
  - Aggressive: Fast movement toward player
  - Attacking: Direct charge at player

### Light Exposure System
- **Detection**: Enemies in flashlight beam are tracked
- **Timer**: Each enemy has individual light exposure counter
- **Threshold**: When timer exceeds light tolerance, enemy becomes aggressive
- **Recovery**: Enemies can return to hidden state if light is removed

## Visual Design & Atmosphere (Mobile-Optimized)

### Game Viewpoint
- **Perspective**: Top-down 2D (bird's eye view)
- **Camera**: Fixed overhead view following the player
- **Movement Direction**: Player moves upward (forward) along the path
- **Lateral Movement**: Left/right movement across path width
- **Flashlight Beam**: Projects outward from player in cone shape, visible from above

### Environment Elements
- **Graveyard Path**: Winding stone path with varying width
- **Gravestones**: 2-3 variations (reduced for mobile performance)
- **Tree Shadows**: Simple dark silhouettes that obscure vision
- **Fog Layer**: Single atmospheric fog layer (simplified from multiple)
- **Atmospheric Particles**: Minimal floating dust particles

### Lighting & Shadows
- **Flashlight Beam**: Soft, cone-shaped light with simplified falloff
- **Environmental Darkness**: Deep shadows everywhere except player's light
- **Fog Interaction**: Light cuts through fog, creating atmospheric beams
- **Dynamic Shadows**: Simple moving shadows from trees and gravestones

### Color Palette
- **Primary**: Deep blacks, dark grays, muted earth tones
- **Accent**: Warm yellow-white from flashlight
- **Enemy Eyes**: White, red, and reflective blue
- **Environment**: Stone grays, dark browns, muted greens

## Technical Implementation (Mobile-First)

### Core Systems
1. **Player Controller** (`scripts/player/sprite_2d.gd`)
   - Path-based movement system
   - Touch-optimized flashlight angle and range control
   - Enemy detection and light exposure tracking
   - Programmatic light texture generation (mobile-optimized)

2. **Enemy AI** (`scripts/enemy/shadow_creature.gd`)
   - Simplified state machine for behavior management
   - Light exposure timer system
   - Movement and attack patterns (mobile-optimized speeds)
   - Programmatic visual component creation

3. **Environment Manager** (`scripts/GraveyardBackground.gd`)
   - Infinite scrolling background system
   - Simplified element spawning (gravestones, trees, fog)
   - Minimal atmospheric particle management
   - Single-layer parallax scrolling

4. **Enemy Spawner** (`scripts/enemy/EnemySpawner.gd`)
   - Dynamic enemy spawning based on difficulty
   - Spawn rate and position management
   - Difficulty curve progression
   - Enemy type distribution

### Scene Structure
- **Main Game Scene** (`scenes/game/game.tscn`)
  - Player node with collision and flashlight
  - Simplified graveyard background system
  - Enemy spawner
  - Game manager integration

- **Enemy Template** (`scenes/enemy/ShadowCreature.tscn`)
  - Area2D with collision detection
  - Script attachment for behavior
  - Debug label for eye type

### Asset Requirements (Mobile-Optimized)

#### Images (Programmatically Generated)
- **Flashlight Beam**: Soft circular light texture (32x32 - mobile-optimized)
- **Enemy Bodies**: Simple shadow creature silhouettes
- **Eye Textures**: White, red, and reflective eye sprites
- **Shadow Effects**: Simple dark aura and shadow textures

#### Images (Preloaded Assets)
- **Gravestones**: 2-3 variations of stone markers
- **Tree Shadows**: Simple dark tree silhouette textures
- **Fog Textures**: Single atmospheric fog texture
- **Particle Textures**: Simple dust and atmospheric particles

#### Audio
- **Ambient Sounds**: Wind, rustling, distant howls
- **Enemy Sounds**: Creature roars, movement sounds
- **Player Sounds**: Footsteps, flashlight clicks
- **Music**: Atmospheric, tension-building soundtrack

## Game Flow & Progression

### Difficulty Scaling
- **Spawn Rate**: Increases over time (0.2 + difficulty_curve * 0.15) - mobile-optimized
- **Enemy Count**: Maximum enemies capped at 6 (mobile performance)
- **Light Tolerance**: Enemies become more sensitive to light
- **Movement Speed**: Enemies move faster as difficulty increases

### Progression Elements
- **Distance Tracking**: Player progress measured in meters
- **Milestone Markers**: Special gravestones or crypts every 100m
- **Safe Zones**: Brief respites at milestones
- **Visual Changes**: Environment becomes more ominous over time

### Win/Lose Conditions
- **Death**: Player hit by aggressive enemy
- **Survival**: Infinite progression (no win condition)
- **Score**: Distance traveled before death
- **Restart**: Return to beginning with same difficulty curve

## User Interface (Mobile-Optimized)

### HUD Elements
- **Distance Counter**: Large, readable meters traveled display
- **Flashlight Battery**: Visual indicator of light strength
- **Enemy Warning**: Subtle indicators when enemies are nearby
- **Death Screen**: Game over with final distance and restart option

### Touch Controls
- **Left Screen Half**: Touch and drag for lateral movement
- **Right Screen Half**: Touch and drag for flashlight angle
- **Movement Zone**: Clear visual indication of movement area
- **Flashlight Zone**: Clear visual indication of flashlight control area
- **Touch Sensitivity**: Optimized for thumb movement and precision

### Alternative Control Schemes
- **Virtual Joystick**: Optional left-side joystick for movement
- **Button Controls**: Optional on-screen buttons for movement
- **Gyroscope**: Optional tilt controls for flashlight angle
- **Accessibility**: Large touch targets and adjustable sensitivity

## Performance Considerations (Mobile-First)

### Optimization Strategies
- **Object Pooling**: Aggressive reuse of enemy and environment objects
- **Culling**: Only render objects within flashlight range
- **LOD System**: Reduce detail for distant objects
- **Texture Atlasing**: Combine small textures into larger sheets
- **Mobile GPU Optimization**: Use mobile-friendly shaders and effects

### Memory Management
- **Asset Preloading**: Load all required assets at start
- **Dynamic Unloading**: Remove off-screen objects immediately
- **Texture Streaming**: Load textures as needed
- **Garbage Collection**: Minimize object creation/destruction
- **Memory Caps**: Strict limits for mobile device compatibility

### Mobile Performance Targets
- **Frame Rate**: 30 FPS minimum (mobile-optimized)
- **Memory Usage**: Under 256MB (mobile constraint)
- **Load Times**: Under 3 seconds (mobile expectation)
- **Object Count**: Maximum 50 active objects (mobile performance)
- **Battery Usage**: Optimized for extended play sessions

## Future Enhancements

### Additional Mechanics
- **Battery System**: Limited flashlight power requiring resource management
- **Multiple Paths**: Forking paths with different difficulty levels
- **Power-ups**: Temporary light enhancements or enemy repellents
- **Weather Effects**: Rain, wind affecting visibility and gameplay

### Content Expansion
- **New Enemy Types**: Different behaviors and visual styles
- **Environmental Hazards**: Traps and obstacles on the path
- **Story Elements**: Graveyard lore and narrative progression
- **Achievement System**: Unlockable content and challenges

### Mobile-Specific Features
- **Offline Play**: No internet connection required
- **Cloud Save**: Optional progress synchronization
- **Social Features**: Share high scores and achievements
- **Mobile Notifications**: Daily challenges and reminders

## Implementation Priority

### Phase 1: Core Systems (Mobile-Optimized)
1. Touch-optimized player movement and flashlight mechanics
2. Simplified enemy AI and state machine
3. Basic environment with scrolling background
4. Basic enemy spawning system

### Phase 2: Polish & Atmosphere
1. Mobile-optimized visual effects and lighting
2. Sound system and audio cues
3. Improved enemy behaviors and variety
4. Environmental detail and atmosphere

### Phase 3: Content & Features
1. Additional enemy types and behaviors
2. Environmental hazards and obstacles
3. Progression systems and milestones
4. UI polish and mobile user experience improvements

## Technical Notes

### Godot Version Compatibility
- **Minimum**: Godot 4.0+
- **Target**: Godot 4.5+
- **Mobile Export**: Android and iOS support required

### Mobile Platform Requirements
- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 12.0+
- **Screen Resolutions**: Support for various mobile screen sizes
- **Touch Input**: Multi-touch support for controls

### Code Standards
- **Scripting**: GDScript with mobile performance in mind
- **Node Structure**: Clean, logical hierarchy optimized for mobile
- **Signal Usage**: Proper event-driven architecture
- **Resource Management**: Efficient asset loading and unloading for mobile
- **Touch Handling**: Proper touch event management and gesture recognition


Possible assets
https://itch.io/search?type=games&q=graveyard&classification=assets