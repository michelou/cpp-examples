// https://fekir.info/post/destructure-cpp-function/

#include <tuple>
#include <cstddef>
#include <iostream>

template <typename T>
struct function_traits : function_traits<decltype(&T::operator())> {};

template <typename R, typename... Args>
struct function_traits<R(Args...)>
{
    static constexpr std::size_t arity = sizeof...(Args);
    template<std::size_t N>
    using argn = typename std::tuple_element<N, std::tuple<Args...>>::type;

    using result = R;

#if __cplusplus >= 201703L
    static constexpr bool is_noexcept = false;
#endif
    static constexpr bool is_variadic = false;

    using ptr = R (*)(Args...);
};

#if __cplusplus >= 201703L
template <typename R, typename... Args>
struct function_traits<R(Args...) noexcept> : function_traits<R(Args...)>
{
    static constexpr bool is_noexcept = true;
    using ptr = R (*)(Args...) noexcept;
};
#endif
template <typename R, typename... Args>
struct function_traits<R(Args..., ...)> : function_traits<R(Args...)>
{
    static constexpr bool is_variadic = true;
    using ptr = R (*)(Args..., ...);
};
#if __cplusplus >= 201703L
template <typename R, typename... Args>
struct function_traits<R(Args..., ...) noexcept> : function_traits<R(Args...) noexcept>
{
    static constexpr bool is_noexcept = true;
    static constexpr bool is_variadic = true;
    using ptr = R (*)(Args..., ...) noexcept;
};
#endif



#define F_TRAIT(NOEXCEPT)\
    template <typename R, typename... Args> \
    struct function_traits<R(*)(Args...) NOEXCEPT>: function_traits<R(Args...) NOEXCEPT>{}; \
    template <typename R, typename... Args> \
    struct function_traits<R(*)(Args..., ...) NOEXCEPT>: function_traits<R(Args..., ...) NOEXCEPT>{}; \
    template <typename R, typename... Args> \
    struct function_traits<R(&)(Args...) NOEXCEPT>: function_traits<R(Args...) NOEXCEPT>{}; \
    template <typename R, typename... Args> \
    struct function_traits<R(&)(Args..., ...) NOEXCEPT>: function_traits<R(Args..., ...) NOEXCEPT>{}; \

F_TRAIT(noexcept(false));
#if __cplusplus >= 201703L
F_TRAIT(noexcept(true));
#endif
#undef F_TRAIT

#define F_AB_TRAIT_I(MOD, NOEXCEPT)\
    template <typename R, typename... Args> \
    struct function_traits<R(Args...) MOD NOEXCEPT>: function_traits<R(Args...) NOEXCEPT>{}; \
    template <typename R, typename... Args> \
    struct function_traits<R(Args..., ...) MOD NOEXCEPT>: function_traits<R(Args...) NOEXCEPT>{}

#if __cplusplus >= 201703L
#define F_AB_TRAIT(MOD)\
    F_AB_TRAIT_I(MOD, noexcept(false)); \
    F_AB_TRAIT_I(MOD, noexcept(true))
#else
#define F_AB_TRAIT(MOD) F_AB_TRAIT_I(MOD, noexcept(false));
#endif
F_AB_TRAIT(const volatile   );
F_AB_TRAIT(const            );
F_AB_TRAIT(      volatile   );
F_AB_TRAIT(const volatile & );
F_AB_TRAIT(const          & );
F_AB_TRAIT(      volatile & );
F_AB_TRAIT(               & );
F_AB_TRAIT(const volatile &&);
F_AB_TRAIT(const          &&);
F_AB_TRAIT(      volatile &&);
F_AB_TRAIT(               &&);
#undef F_AB_TRAIT
#undef F_AB_TRAIT_I

template <typename C, typename R, typename... Args>
struct function_traits<R(C::*)(Args...)>: function_traits<R(Args...)>{
    using owner = C;
};

#if __cplusplus >= 201703L
template <typename C, typename R, typename... Args>
struct function_traits<R(C::*)(Args...) noexcept>: function_traits<R(Args...) noexcept>{
    using owner = C;
};
#endif
template <typename C, typename R, typename... Args>
struct function_traits<R(C::*)(Args..., ...)>: function_traits<R(Args..., ...)>{
    using owner = C;
};
#if __cplusplus >= 201703L
template <typename C, typename R, typename... Args>
struct function_traits<R(C::*)(Args..., ...) noexcept>: function_traits<R(Args..., ...) noexcept>{
    using owner = C;
};
#endif

#define MF_TRAIT_I(MOD, NOEXCEPT)\
    template <typename C, typename R, typename... Args> \
    struct function_traits<R(C::*)(Args...) MOD NOEXCEPT>: function_traits<R(Args...) NOEXCEPT>{\
        using owner = C MOD;\
    }; \
    template <typename C, typename R, typename... Args> \
    struct function_traits<R(C::*)(Args..., ...) MOD NOEXCEPT>: function_traits<R(Args..., ...) NOEXCEPT>{\
        using owner = C MOD;\
    }

#if __cplusplus >= 201703L
#define MF_TRAIT(MOD)\
    MF_TRAIT_I(MOD, noexcept(false));\
    MF_TRAIT_I(MOD, noexcept(true))
#else
#define MF_TRAIT(MOD) MF_TRAIT_I(MOD, noexcept(false))
#endif

MF_TRAIT(const             );
MF_TRAIT(               &  );
MF_TRAIT(const          &  );
MF_TRAIT(               && );
MF_TRAIT(const          && );
MF_TRAIT(      volatile    );
MF_TRAIT(const volatile    );
MF_TRAIT(      volatile &  );
MF_TRAIT(const volatile &  );
MF_TRAIT(      volatile && );
MF_TRAIT(const volatile && );
#undef MF_TRAIT


// tests:

using T1 = int(*) (...);
using T2 = void (int);
using T3 = void (&) (int);
#if __cplusplus >= 201703L
using T4 = void (int) noexcept;
#endif

static_assert(std::is_same<function_traits<T1>::result, int>::value, "");
static_assert(std::is_same<function_traits<T2>::result, void>::value, "");
static_assert(std::is_same<function_traits<T3>::result, void>::value, "");

static_assert(function_traits<T1>::arity == 0, "");
static_assert(function_traits<T2>::arity == 1, "");

static_assert(std::is_same<function_traits<T2>::argn<0>, int>::value, "");
static_assert(std::is_same<function_traits<T3>::argn<0>, int>::value, "");

static_assert(std::is_same<function_traits<T1>::ptr, T1>::value, "");
static_assert(std::is_same<function_traits<T2>::ptr, T2*>::value, "");
static_assert(std::is_same<function_traits<T3>::ptr, T2*>::value, "");

#if __cplusplus >= 201703L
static_assert(!function_traits<T1>::is_noexcept);
static_assert( function_traits<T4>::is_noexcept);
#endif

struct fwd;
#if __cplusplus >= 201703L
using H1 = int(fwd::*)() noexcept;
#endif
using H2 = int(fwd::*)() const;
using H3 = int&(fwd::*)();
using H4 = void(fwd::*)(int);
using H5 = void(fwd::*)(int, bool, char*);
using H6 = int(fwd::*)(...) volatile;


#if __cplusplus >= 201703L
static_assert( function_traits<H1>::is_noexcept);
static_assert(!function_traits<H2>::is_noexcept);
#endif

static_assert(std::is_same<function_traits<H2>::result, int>::value, "");
static_assert(std::is_same<function_traits<H3>::result, int&>::value, "");
static_assert(std::is_same<function_traits<H4>::result, void>::value, "");
static_assert(std::is_same<function_traits<H6>::result, int>::value, "");

static_assert(function_traits<H2>::arity == 0, "");
static_assert(function_traits<H4>::arity == 1, "");

static_assert(std::is_same<function_traits<H4>::argn<0>, int>::value, "");
static_assert(std::is_same<function_traits<H5>::argn<2>, char*>::value, "");


static_assert(std::is_same<function_traits<H2>::owner, const fwd>::value, "");
static_assert(std::is_same<function_traits<H3>::owner, fwd>::value, "");


#if __cplusplus >= 201703L
static_assert(std::is_same<function_traits<H1>::ptr, int(*)() noexcept>::value);
#endif
static_assert(std::is_same<function_traits<H2>::ptr, int(*)()>::value, "");

auto l = []{return 42;};
static_assert(function_traits<decltype(l)>::arity == 0, "");

struct s{
    int operator()(bool);
};
static_assert(function_traits<s>::arity == 1, "");

struct s2{
    int operator()(bool, bool);
};
static_assert(function_traits<s2>::arity == 2, "");


int main() {
    std::cout << "__cplusplus=" << __cplusplus << std::endl;
    return 0;
}