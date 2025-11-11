package edu.fateczl.book.Controller;

import edu.fateczl.book.DTO.UpdateAutorDTO;
import edu.fateczl.book.DTO.UpdateCategoriaDTO;
import edu.fateczl.book.Models.Autor;
import edu.fateczl.book.Models.Categoria;
import edu.fateczl.book.Repository.AutorRepository;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;

@RestController
@RequestMapping("/autor")
public class AutorController {

    private final AutorRepository autorRepository;
    private final ModelMapper modelMapper;

    public AutorController(AutorRepository autorRepository, ModelMapper modelMapper) {
        this.autorRepository = autorRepository;
        this.modelMapper = modelMapper;
    }

    @GetMapping
    public @ResponseBody Iterable<Autor> getAllAutores(@RequestParam(required = false) String nome) {
        if (nome == null || nome.isBlank())
            return autorRepository.findAll();

        return autorRepository.getAllByNomeContainsIgnoreCase(nome);
    }

    @GetMapping(path="{id}")
    public @ResponseBody Optional<Autor> getAutorById(@PathVariable Long id) {
        return autorRepository.findById(id);
    }

    @PostMapping
    public @ResponseBody Autor createAutor(@RequestBody Autor autor){
        return autorRepository.save(autor);
    }

    @PutMapping("/{id}")
    public @ResponseBody Autor updateAutor(@PathVariable Long id, @RequestBody UpdateAutorDTO dto) {
        var autor = autorRepository.getById(id);

        if (autor == null)
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Autor não existe!");

        Autor novoAutor = modelMapper.map(dto, Autor.class);
        novoAutor.setId(id);

        return autorRepository.save(novoAutor);
    }

    @DeleteMapping(path="/{id}")
    public @ResponseBody Boolean deleteAutor(@PathVariable Long id){
        autorRepository.deleteById(id);
        return true;
    }
}
