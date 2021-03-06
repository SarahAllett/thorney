class PathManager
  def fixture_parent_folder(path_hash)
    parent_folder = path_hash[:fixture_path].split('/')
    parent_folder.pop
    parent_folder = parent_folder.join('/')

    full_path(parent_folder + '/')
  end

  def spec_and_fixture(path)
    return controller_spec_and_fixture(path) if controller_fixture?(path)

    generic_spec_and_fixture(path)
  end

  def full_path(path)
    root = __dir__.chomp('app/services')

    root + path
  end

  def list_paths(paths, stdout: $stdout)
    paths.each do |path|
      stdout.puts path
    end
  end

  private

  def generic_spec_and_fixture(path)
    spec_fixture_hash(spec_path(path), fixture_name(path), path)
  end

  def controller_spec_and_fixture(path)
    spec_fixture_hash(controller_spec_path(path), fixture_name(path), path, controller_method: controller_method(path))
  end

  def controller_fixture?(path)
    path.split('/')[2] == 'controllers'
  end

  def controllers_index(split_path)
    split_path.find_index('controllers')
  end

  def controller_method(path)
    split_path = path.split('/')

    split_path[controllers_index(split_path) + 2] if controller_spec?(path)
  end

  def controller_spec?(path)
    path.include?('_controller')
  end

  def controller_spec_path(path)
    path = (path.split('/') - ['fixtures']).join('/')

    split_path = full_path(path).split('/')

    if controller_spec?(split_path[controllers_index(split_path) + 1])
      split_path.delete_at(controllers_index(split_path) + 2)
      split_path.insert(controllers_index(split_path), 'integration')
    end

    split_path.pop
    split_path.join('/') + '_spec.rb'
  end

  def spec_path(path)
    path = (path.split('/') - ['fixtures']).join('/')
    split_path = full_path(path).split('/')

    split_path.pop
    split_path.join('/') + '_spec.rb'
  end

  def fixture_name(path)
    path.split('/').last
  end

  def spec_fixture_hash(spec, fixture_name, fixture_path, controller_method: nil)
    {}.tap do |hash|
      hash[:spec] = spec
      hash[:fixture_name] = fixture_name
      hash[:fixture_path] = fixture_path
      hash[:controller_method] = controller_method if controller_method
    end
  end
end
