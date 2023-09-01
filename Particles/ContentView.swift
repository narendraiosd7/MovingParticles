//
//  ContentView.swift
//  Particles
//
//  Created by Narendra Vadde on 31/08/23.
//

import SwiftUI

struct EmitterView: View {
    private struct ParticleView: View {
        @State private var isActive: Bool = false
        
        let image: Image
        let position: ParticleState<CGPoint>
        let opacity: ParticleState<Double>
        let rotation: ParticleState<Angle>
        let scale: ParticleState<CGFloat>
        
        var body: some View {
            image
                .opacity(isActive ? opacity.end : opacity.start)
                .scaleEffect(isActive ? scale.end : scale.start)
                .rotationEffect(isActive ? rotation.end : rotation.start)
                .position(isActive ? position.end : position.start)
                .onAppear { self.isActive = true }
        }
    }
    
    private struct ParticleState<T> {
        var start: T
        var end: T

        init(_ start: T, _ end: T) {
            self.start = start
            self.end = end
        }
    }

    var images: [String]
    var particleCount: Int
    
    var creationPoint = UnitPoint.center
    var creationRange = CGSize.zero

    var colors = [Color.white]
    var blendMode = BlendMode.normal
    
    var angle = Angle.zero
    var angleRange = Angle.zero

    var opacity = 1.0
    var opacityRange = 0.0
    var opacitySpeed = 0.0
    
    var rotation = Angle.zero
    var rotationRange = Angle.zero
    var rotationSpeed = Angle.zero
    
    var scale: CGFloat = 1
    var scaleRange: CGFloat = 0
    var scaleSpeed: CGFloat = 0
    
    var speed = 50.0
    var speedRange = 0.0
    
    var animation = Animation.linear(duration: 1).repeatForever(autoreverses: false)
    var animationDelayThreshold = 0.0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<self.particleCount, id: \.self) { i in
                    ParticleView(
                        image: Image(self.images.randomElement()!),
                        position: self.position(in: geo),
                        opacity: self.makeOpacity(),
                        rotation: self.makeRoatation(),
                        scale: self.makeScale()
                    )
                    .animation(self.animation.delay(Double.random(in: 0...self.animationDelayThreshold)))
                    .colorMultiply(self.colors.randomElement() ?? .white)
                    .blendMode(self.blendMode)
                }
            }
        }
    }
    
    private func position(in proxy: GeometryProxy) -> ParticleState<CGPoint> {
        let halfCreationRangeWidth = creationRange.width / 2
        let halfCreationRangeHeight = creationRange.height / 2

        let creationOffsetX = CGFloat.random(in: -halfCreationRangeWidth...halfCreationRangeWidth)
        let creationOffsetY = CGFloat.random(in: -halfCreationRangeHeight...halfCreationRangeHeight)

        let startX = Double(proxy.size.width * (creationPoint.x + creationOffsetX))
        let startY = Double(proxy.size.height * (creationPoint.y + creationOffsetY))
        let start = CGPoint(x: startX, y: startY)
        
        let halfSpeedRange = speedRange / 2
        let actualSpeed = speed + Double.random(in: -halfSpeedRange...halfSpeedRange)
        
        let halfAngleRange = angleRange.radians / 2
        let actualDirection = angle.radians + Double.random(in: -halfAngleRange...halfAngleRange)
        
        let finalX = cos(actualDirection - .pi / 2) * actualSpeed
        let finalY = sin(actualDirection - .pi / 2) * actualSpeed
        let end = CGPoint(x: startX + finalX, y: startY + finalY)
        
        return ParticleState(start, end)
    }
    
    private func makeOpacity() -> ParticleState<Double> {
        let halfOpacityRange = opacityRange / 2
        let randomOpacity = Double.random(in: -halfOpacityRange...halfOpacityRange)
        return ParticleState(randomOpacity + opacity, opacity + opacitySpeed + randomOpacity)
    }
    
    private func makeScale() -> ParticleState<CGFloat> {
        let halfScaleRange = scaleRange / 2
        let randomScale = Double.random(in: -halfScaleRange...halfScaleRange)
        return ParticleState(scale + randomScale, scale + scaleSpeed + randomScale)
    }
    
    private func makeRoatation() -> ParticleState<Angle> {
        let halfRotationRange = (rotationRange / 2).radians
        let randomRotation = Double.random(in: -halfRotationRange...halfRotationRange)
        let randomRotationAngle = Angle(radians: randomRotation)
        return ParticleState(rotation + randomRotationAngle, rotation + rotationSpeed + randomRotationAngle)
    }
}

struct ContentView: View {
    @State private var particleMode = 0
    let modes = ["Confetti", "Explosion", "Fireflies", "Magic", "Rain", "Smoke", "Snow"]

    var body: some View {
        VStack {
            ZStack {
                if particleMode == 0 {
                    // confetti
                    EmitterView(images: ["confetti"], particleCount: 50, creationPoint: .init(x: 0.5, y: -0.1), creationRange: CGSize(width: 1, height: 0), colors: [.red, .yellow, .blue, .green, .white, .orange, .purple], angle: .degrees(180), angleRange: .radians(.pi / 4), rotationRange: .radians(.pi * 2), rotationSpeed: .radians(.pi), scale: 0.6, speed: 1200, speedRange: 800, animation: Animation.linear(duration: 5).repeatForever(autoreverses: false), animationDelayThreshold: 5).id(1)
                } else if particleMode == 1 {
                    // explosion
                    EmitterView(images: ["spark"], particleCount: 500, colors: [.red], blendMode: .screen, angleRange: .degrees(360), opacitySpeed: -1, scale: 0.4, scaleRange: 0.1, scaleSpeed: 0.3, speed: 60, speedRange: 80, animation: Animation.easeOut(duration:     1).repeatForever(autoreverses: false)).id(2)
                } else if particleMode == 2 {
                    // fireflies
                    EmitterView(images: ["spark"], particleCount: 100, creationRange: CGSize(width: 1, height: 1), colors: [.yellow], blendMode: .screen, angleRange: .degrees(360), opacitySpeed: -1, scale: 0.5, scaleRange: 0.2, scaleSpeed: -0.2, speed: 120, speedRange: 120, animation: Animation.easeInOut(duration: 1).repeatForever(autoreverses: false), animationDelayThreshold: 1).id(3)
                } else if particleMode == 3 {
                    // magic
                    EmitterView(images: ["spark"], particleCount: 200, colors: [Color(red: 0.5, green: 1, blue: 1)], blendMode: .screen, angleRange: .degrees(360), opacitySpeed: -1, scale: 0.5, scaleRange: 0.2, scaleSpeed: -0.2, speed: 120, speedRange: 120, animation: Animation.easeOut(duration: 1).repeatForever(autoreverses: false), animationDelayThreshold: 1).id(4)
                } else if particleMode == 4 {
                    // rain
                    EmitterView(images: ["line"], particleCount: 100, creationPoint: .init(x: 0.5, y: -0.1), creationRange: CGSize(width: 1, height: 0), colors: [Color(red: 0.8, green: 0.8, blue: 1)], angle: .degrees(180), opacityRange: 1, scale: 0.6, speed: 1000, speedRange: 400, animation: Animation.linear(duration: 1).repeatForever(autoreverses: false), animationDelayThreshold: 1).id(5)
                } else if particleMode == 5 {
                    // smoke
                    EmitterView(images: ["spark"], particleCount: 200, colors: [.gray], blendMode: .screen, angleRange: .degrees(90), opacitySpeed: -1, scale: 0.3, scaleRange: 0.1, scaleSpeed: 1, speed: 100, speedRange: 80, animation: Animation.linear(duration: 3).repeatForever(autoreverses: false), animationDelayThreshold: 3).id(6)
                } else if particleMode == 6 {
                    // snow
                    EmitterView(images: ["spark"], particleCount: 100, creationPoint: .init(x: 0.5, y: -0.1), creationRange: CGSize(width: 1, height: 0), colors: [.white], angle: .degrees(180), angleRange: .degrees(10), opacityRange: 1, scale: 0.4, scaleRange: 0.4, speed: 2000, speedRange: 1500, animation: Animation.linear(duration: 10).repeatForever(autoreverses: false), animationDelayThreshold: 10).id(7)
                }
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)

            Picker("Select a mode", selection: $particleMode) {
                ForEach(0..<modes.count, id: \.self) { mode in
                    Text(self.modes[mode])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
