
## Processus ##


**Pour la partie processus, il nous ai demandé de récupérer les choses suivantes.**


- Le PID (Numéro du processus)


- Le Nom/UID (User qui à lancé le processus)


- Le Status/C (evalue la priorité du processus, plus il est élever, et plus il est prioritaire au autre processus.)


- Le Parent ID/PPID (Numéro de l'identifiant du processus parent )


- La ligne de commande qui lance le processus


- La possibilité de Kill le processus (en mode simple et en mode forcé).


## Commande du processus ##


- Pour commencé vous aller devoir ouvrir votre terminal, et une fois sur votre debian vous marquerez :

- ps -ef-

**ps = commande pour les status du processus**

**e = affiche tous les processus**

**f = montre un affichage détaillé des processus**

- Cela va vous afficher toute les informations recherchés un peu plus haut.

- Si vous rechercher le PID d'un seul utilisateur, vous pouvez marquer : 

- ps -u (nom de l'user)

**-u = recherche un user en particulier**

## Avoir la possibilité de Kill un processus ##

- La commande Kill permet à son utilisateur de tuer/supprimer un processus en cours. Pour se faire vous aurez besoin du PID de ce processus et marquer la commande suivante : 

- Kill (PID)

- Vous pouvez aussi en supprimer plusieur d'un seul coup avec la commande : 

- Kill (PID) (PID) (PID) ...
Tant que vous pouvez mettre plusieur  PID à la suite.


**Forcer un Kill de processus**

- Si vous rencontrer un problème a kill un processus vous pouvez forcer cette suppression malgré tout. Pour y arriver vous devrez utiliser la commnde suivante :

- Kill -9 (PID)


- Cette action aura comme objectif de supprimer le processus sans lui laisser le temps de s'arreter normalement, c'est un moyen de forcer l'arrêt d'un processus, cependant cette commande est a utiliser seulement si à cause d'un problème l'arrêt du processus est impossible avec la méthode simple.