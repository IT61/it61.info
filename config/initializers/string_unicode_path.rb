class String
   def downcase
      if !self.frozen?
        Unicode::downcase(self.force_encoding('utf-8'))
      else
        Unicode::downcase(self)
      end
   end

   def downcase!
      self.replace(downcase)
   end

   def upcase
      if !self.frozen?
        Unicode::upcase(self.force_encoding('utf-8'))
      else
        Unicode::upcase(self)
      end
   end

   def upcase!
      self.replace upcase
   end

   def capitalize
      if !self.frozen?
        Unicode::capitalize(self.force_encoding('utf-8'))
      else
        Unicode::capitalize(self)
      end
   end

   def capitalize!
      self.replace capitalize
   end
end
