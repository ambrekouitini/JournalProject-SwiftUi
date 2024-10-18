# Journal Émotionnel

## Description

Ce projet est une application iOS développée en SwiftUI qui permet aux utilisateurs de suivre leurs émotions quotidiennes. L'application offre une interface intuitive et esthétique pour enregistrer et visualiser l'évolution de ses émotions au fil du temps.

## Principales fonctionnalités

1. **Enregistrement quotidien des émotions** : Les utilisateurs peuvent sélectionner une émotion pour représenter leur journée.

2. **Calendrier des émotions** : Visualisation mensuelle des émotions enregistrées avec un code couleur intuitif.

3. **Historique détaillé** : Possibilité de consulter les détails des émotions passées, incluant une description et un conseil personnalisé en cliquant sur une date du calendrier possédant une couleur.

4. **Ajout rétrospectif** : Les utilisateurs peuvent ajouter des émotions pour des dates passées, en cliquant sur un date qui n'a pas de couleur.

5. **Journal personnel** : Fonction pour écrire et consulter des entrées de journal quotidiennes.

## Comment utiliser

### Connexion

Pour se connecter à l'application, utilisez les identifiants suivants :
- Nom d'utilisateur : `Root`
- Mot de passe : `Root`

### Enregistrer une émotion

1. Sur l'écran principal, sélectionnez l'emoji correspondant à votre émotion du jour.
2. L'émotion est automatiquement enregistrée et apparaîtra dans le calendrier.

### Consulter le calendrier

- Naviguez entre les mois en utilisant les flèches.
- Appuyez sur une date pour voir les détails de l'émotion enregistrée ou pour ajouter une émotion si la date est passée.

### Voir les détails d'une émotion

Appuyez sur une date colorée dans le calendrier pour ouvrir une fenêtre pop-up montrant :
- L'émotion sélectionnée
- Une description de cette émotion
- Un conseil personnalisé

### Utiliser le journal

1. Accédez à la section journal depuis l'onglet "Journal" en bas de l'écran.
2. Pour créer une nouvelle entrée, appuyez sur le bouton "+" en haut à droite.
3. Écrivez votre entrée de journal dans la zone de texte prévue à cet effet.
4. Appuyez sur "Sauvegarder" pour enregistrer votre entrée.
5. Pour consulter ou modifier une entrée existante, appuyez simplement sur la date correspondante dans la liste des entrées.

## Développement

Ce projet a été développé en utilisant SwiftUI et suit les principes de conception moderne d'iOS. Il utilise une architecture MVVM (Model-View-ViewModel) pour une séparation claire des responsabilités et une meilleure maintenabilité du code.
