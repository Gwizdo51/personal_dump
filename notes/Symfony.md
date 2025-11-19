# Symfony notes

## Controllers and routes

Console commands : `php bin/console` -> lists all available commands to interact with Symfony

Create a controller : `php bin/console make:controller <controller_class_name>`

Every route is registered in `config/routes.yaml` :
```yaml
controllers:
    resource:
        path: ../src/Controller/
        namespace: App\Controller
    type: attribute

home:
    path: /
    controller: App\Controller\HomeController::index
```

Better way : don't touch `routes.yaml`, but modify the controller :
```php
final class HomeController extends AbstractController {

    #[Route(path: "/", name: "home")]
    public function index(): Response {
        return new Response("Hello world!");
    }

}
```

Get the query parameters :
```php
// use Symfony\Component\HttpFoundation\Request;

#[Route('/', name: 'home')]
public function index(Request $request): Response {
    $name = $request->query->get('name', 'default');
    return new Response("Hello {$name}!");
}
```

To explore variables :
- `dump($var)`
- `dd($var)` (dump & die)

To get the list of all the defined routes : `php bin/console debug:router`

Route parameters :
```php
#[Route('/{id}', name: 'home.testId', requirements: ['id' => '\d+'])]
public function testId(Request $request, int $id): Response {
    // dd($request->attributes);
    dd($id);
}
```

Return JSON objects :
```php
#[Route('/{id}', name: 'home.testId', requirements: ['id' => '\d+'])]
public function testId(Request $request, int $id): JsonResponse {
    return $this->json([
        'id' => $id,
    ]);
}
```

## Html template engine: Twig

[Doc de Twig](https://twig.symfony.com/doc/3.x/)

reference :
- `extends` : used to extend a template from another one - limited to a single one per template
- `use` : used to import other templates

Render a Twig template from a controller :
```php
return $this->render('home/index.html.twig');
```

Send data from the controller to the template :
- In the controller :
    ```php
    return $this->render('home/index.html.twig', [
        'data' => 'Some useful data',
    ]);
    ```
- In the template :
    ```twig
    {{ data }}
    ```

Send table data :
- Controller :
    ```php
    return $this->render('home/index.html.twig', [
        'person' => [
            'firstName' => 'John',
            'lastName' => 'Doe',
        ],
    ]);
    ```
- Template :
    ```twig
    {{ person.firstName }} {{ person.lastName }}
    ```

Concatenate strings :
```twig
{{ person.firstName ~ ' ' ~ person.lastName }}
```

Filters :
```twig
{{ person.firstName | upper }}
```

Display unescaped HTML :
```twig
{{ htmlValue | raw }}
```

Links : use the name of the routes defined in the controller :
- `url` outputs the full URL of the page
    ```twig
    {{ url('home.welcome') }}
    ```
- `path` outputs only the relative path to the page
    ```twig
    {{ path('home.welcome') }}
    ```

Dump variables to inspect them :
```twig
{{ dump(app) }}
```

Basic conditions :
```twig
{{ app.current_route starts with 'home' ? 'Home pages' : 'not Home pages' }}
```

## Doctrine ORM

Create entities : `php bin/console make:entity`

Make migrations : `php bin/console make:migrations`

Migrate : `php bin/console doctrine:migrations:migrate`

Update schema : `php bin/console doctrine:schema:update`

See SQL before updating schema : `php bin/console doctrine:schema:update --dump-sql`

Check if the schema is UTD : `php bin/console doctrine:schema:validate`

## Forms

Create a form class : `php bin/console make:form` (naming convention: `XxxType`)

Make a `$form` object inside the controller :
```php
$form = $this->createForm(CompanyType::class, $company);
```

Override the method used by a form :
- Add a hidden input : `<input type="hidden" name="_method" value="DELETE">`
- Modify Symfony config : `config/framework.yaml` => add `http_method_override: true` to `framework`

Create a custom validator : `php bin/console make:validator`

## Flash to session

Flash a message to the session from the controller : `$this->addFlash('key', 'message');`

Dump the messages flashed in a vue (debug) : `{{ dump(app.flashes) }}`
