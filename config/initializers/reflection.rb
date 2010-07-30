# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: reflections.rb
# 
#

models = []

# Hack, Kludge, Requisite ugly code.
Crux::YogoModel.first
Crux::KefedModel.first

# Reflect Yogo data into memory
models = DataMapper::Reflection.reflect(:yogo, Object, false)

models.each{|m| m.send(:include,Yogo::Model) }
models.each{|m| m.properties.sort! }
