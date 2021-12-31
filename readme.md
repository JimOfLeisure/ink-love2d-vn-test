# Bumpy Road

"Play" this game at https://jimofleisure.itch.io/bumpy-road .

I feel like toying with a game engine and submitting to an Itch.io jam, namely [2021 Variety Megajam](https://itch.io/jam/variety-megajam-2021). I'm going to start with [Love2d's physics tutorial](https://love2d.org/wiki/Tutorial:Physics) code to get the feel for it and then try to make something from there.

My early thoughts are to have a ball roll down a procedurally-generated hill. I'm not sure how I'll turn that into a game, but hey I gotta start somewhere.

## Dev Notes

### The ball drops

I moved the tutorial code to tutorial.lua and made a physics ball that drops. Whee. Some possible next steps:

- Modularize the ball and any entities
- Have each passive entity manage itself (despawn or reset position, velocity, rotation)
- Create a flat slope for the ball(s) to roll down
- Create a **bumpy ~~road~~** slope for them to roll down
- Camera to scroll along with balls
- Continue generating new bits of bumpy road/slope to ride down (using noise)

I don't guess I'll bother uploading the dropping ball to Itch. I might have but don't want to bother with the screenshot.

### The ground exists...and it spins

I got stuck on a temporary test of wanting the "ground" to rotate but finally figured it out. And now the ball resets once it falls below the screen so it repeatedly drops onto the rotating "ground".

Next steps will probably be generating the ground. I now think I'll have controls to vary the angle of the hill, but instead of rotating the ground I'll rotate the camera and change the direction of gravity. That will make placing the generated ground sections easier.

I'm thinking the goal of the game might be a speed challenge to either maintain a high level of speed or cover a set distance as quickly as possible. The catch may be that if the ball launches too far or too long into the air it will deploy a parachute to slow down and land softly before rolling downhill again.

### The ball now rolls down a bumpy surface!

It took me far too long to do this. Rotating gravity was easy; rotating the camera was mind-blowingly tricky, and I'm still unclear on a couple of things.

The ground is in several sections, and as the ball moves to the right, each section in turn will recreate itself to disappear from the left and appear at the right with a continuous bumpy surface. I think this is more efficient than continually removing and adding items to the table, even though I'm still creating and destroying the physics objects.

### Invisible paracutes

I'm pretty happy with the "parachute" physics. I also made adjustments to the ground appears solid and takes up more of the screen. I'm not drawing the parachute; I looked for some free art but haven't found any I don't have to sign up to use.

## Building

The Love2d game is in src/ . The rest of this repo is for building it and preparing to deploy to Itch.io . It relies on node and npm to install Love.js .

- Love2d, node, and npm need to be installed, and zip is needed to make the zip file
- `npm install` downloads Love.js
- `npm run-script build` creates the release/ folder and converts the Love2d project in src/ to html in release/
- `npm run-script zip` will delete any existing bumpy-road.zip file and then create a new one with the contents of release/
- bumpy-road.zip can then be uploaded to Itch.io
- Caddyfile is to configure the caddy webserver which I am using locally. Just run `caddy` in the repo root folder, and the game will be available at http://localhost:2015 after release/ is populated by the build

## Credits / Asset Licensing

### Parachute-icon.png

- Source: https://commons.wikimedia.org/wiki/File:Parachute-icon.png
- File URL: https://upload.wikimedia.org/wikipedia/commons/2/24/Parachute-icon.png
- MiniBjorn, CC BY-SA 3.0 <https://creativecommons.org/licenses/by-sa/3.0>, via Wikimedia Commons
- Image is displayed as rotated based on velocity

## SoccerBall.png

- Source: https://opengameart.org/content/soccer-ball
- Marked as public domain
