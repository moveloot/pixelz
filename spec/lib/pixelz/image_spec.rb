describe Pixelz::Image do
  describe '::send' do
    context 'all parameters provided' do
      it 'saves and returns a new modification request' do
        image = create(:image)
        Pixelz::Image.send(image)
      end
    end
  end
end
