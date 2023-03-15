# Godot-Dialogue-Editor A branching Dialogue System for Games made in the Godot Engine

inspired by the wonderfull Dialogic plugin from https://github.com/coppolaemilio/dialogic

The System contains a Graph Editor for creating branching dialogue files, a basic ui for displaying it and a simple character editor.
The created Dialogue and character files are json files and can be used in other Game Engines that support json.
This plugin also includes a npc scheme file, this file basicly says which information the npcs hold such as name, introduction dialogue, trading dialogue and whatever else your game needs

Creating new Nodes
This plugin comes with basic nodes such as conversation,question, signal nodes, etc, if you personally something you can easily add your own nodes

steps to create your own node:
0. add the "graph_node" group to your new node
1. create or duplicate an existing node and change the code and structure to fit your needs, you can use Dialogue Node as a reference how a node works
2. functions every node needs:
  2.1: clost_request() -> sends a signal to the editor to delete this node, you can just copy paste the 
  code from Dialogue Node
  2.2: resize_request(): optional, also just copy paste
  2.3: save_node(): called when you save or close your dialogue_file, this is all the data it needs to be correctly loaded in the editor agagin, also requires a 'type' attribute that is a string, so that the Interface knows with which it is dealing with.
  2.4: load_node(data): called when the node gets instantiatet, loads the data you have saved in save_node(). you don't have to load the position and size, that is handled by the editor automaticly
3. you have to update the execute_type() function in 'res://addons/Waffles/User Interface/Dialogue Interface.gd' and add your own type.
