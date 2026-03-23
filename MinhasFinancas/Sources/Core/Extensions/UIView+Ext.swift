//
//  UIView+Ext.swift
//  MinhasFinancas
//
//  Created by edson lima on 12/03/26.
//

import UIKit

extension UIView {
    
    /// Inicia o efeito de shimmer na view atual.
    func startShimmering() {
        // Remove qualquer shimmer anterior para evitar sobreposição de camadas
        stopShimmering()
        
        // 1. Configurar o gradiente
        let gradientLayer = CAGradientLayer()
        // Usamos três cores para criar o efeito de um "feixe de luz" passando pelo meio
        gradientLayer.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor
        ]
        
        // As posições iniciais das cores no gradiente
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = bounds
        
        // Configura a direção da animação (da esquerda para a direita)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        // Adiciona um nome à camada para podermos encontrá-la e removê-la depois
        gradientLayer.name = "shimmerLayer"
        layer.addSublayer(gradientLayer)
        
        // 2. Configurar a animação
        let animation = CABasicAnimation(keyPath: "locations")
        // O gradiente começa fora da tela à esquerda e termina fora da tela à direita
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.2 // Velocidade do efeito
        animation.repeatCount = .infinity // Repete infinitamente
        
        // Adiciona a animação à camada
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
    
    /// Para e remove o efeito de shimmer da view.
    func stopShimmering() {
        // Procura por sublayers com o nome "shimmerLayer" e os remove
        layer.sublayers?.filter { $0.name == "shimmerLayer" }.forEach { $0.removeFromSuperlayer() }
    }
}
