# frozen_string_literal: true

require 'mkmf'
require 'numo/narray/alt'

$LOAD_PATH.each do |lp|
  if File.exist?(File.join(lp, 'numo/numo/narray.h'))
    $INCFLAGS = "-I#{lp}/numo #{$INCFLAGS}"
    break
  end
end

unless have_header('numo/narray.h')
  puts 'numo/narray.h not found.'
  exit(1)
end

if RUBY_PLATFORM.match?(/mswin|cygwin|mingw/)
  $LOAD_PATH.each do |lp|
    if File.exist?(File.join(lp, 'numo/narray/libnarray.a'))
      $LDFLAGS = "-L#{lp}/numo/narray #{$LDFLAGS}"
      break
    end
  end
  unless have_library('narray', 'nary_new')
    puts 'libnarray.a not found.'
    exit(1)
  end
end

if RUBY_PLATFORM.include?('darwin') && Gem::Version.new('3.1.0') <= Gem::Version.new(RUBY_VERSION) && try_link(
  'int main(void){return 0;}', '-Wl,-undefined,dynamic_lookup'
)
  $LDFLAGS << ' -Wl,-undefined,dynamic_lookup'
end

$CFLAGS = "#{$CFLAGS} -std=c99"

$srcs = Dir.glob("#{$srcdir}/**/*.c").map { |path| File.basename(path) }
$VPATH << '$(srcdir)/src'

create_makefile('numo/pocketfft/pocketfftext')
